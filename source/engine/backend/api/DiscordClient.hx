package engine.backend.api;

#if FEATURE_DISCORD_RPC
import cpp.Function;
import cpp.ConstCharStar;
import cpp.RawPointer;
import cpp.RawConstPointer;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import Sys.sleep as Sleep;
import Sys.println as Print;

class DiscordClient
{
	public static var clientID(default, set):String = Constants.DEFAULT_DISCORD_CLIENT_ID;
	public static var instance(get, never):DiscordClient;
	static var _instance:Null<DiscordClient> = null;
	static var initialized:Bool = false;

	#if sys
	@:unreflective static var _thread:Thread;
	#end

	private var handlers:DiscordEventHandlers;

	private function new():Void
	{
		Print("Discord Client: Initializing event handlers...");

		handlers = new DiscordEventHandlers();
		handlers.ready = Function.fromStaticFunction(handlers_ready);
		handlers.disconnected = Function.fromStaticFunction(handlers_disconnected);
		handlers.errored = Function.fromStaticFunction(handlers_errored);
	}

	public function initialize():Void
	{
		Print("Discord Client: Initializing connection...");

		Discord.Initialize(clientID, RawPointer.addressOf(handlers), true, null);

		#if sys
		if (_thread == null)
			_thread = Thread.create(() -> startUp());
		#end

		initialized = true;
	}

	function startUp():Void
	{
		while (true)
		{
			if (initialized)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();
			}

			Sleep(#if debug 1.5 #else 3 #end);
		}
	}

	public function shutdown():Void
	{
		Print("Discord Client: Shutting down...");

		initialized = false;
		Discord.Shutdown();
	}

	public function changePresence(?params:Null<DiscordPresenceParams> = null):Void
	{
		if (params == null)
			params = {details: "Random!"};

		Print('Discord Rich Presence Changed: ${params.details + (params.state == null ? "" : " / " + params.state) + (params.largeImageKey == null ? "" : " / " + params.largeImageKey) + (params.largeImageText == null ? "" : " / " + params.largeImageText) + (params.smallImageKey == null ? "" : " / " + params.smallImageKey) + (params.smallImageText == null ? "" : " / " + params.smallImageText)}');
		Discord.UpdatePresence(RawConstPointer.addressOf(buildPresence(params)));
	}

	private function buildPresence(params:DiscordPresenceParams):DiscordRichPresence
	{
		var presence:DiscordRichPresence = new DiscordRichPresence();
		presence.type = DiscordActivityType_Playing;

		// Parameters
		presence.details = cast(params.details, Null<String>);
		presence.state = cast(params.state, Null<String>);
		presence.largeImageKey = cast(params.largeImageKey, Null<String>) ?? "icon";
		presence.largeImageText = cast(params.largeImageText, Null<String>) ?? "Project Version: " + Constants.VERSION;
		presence.smallImageKey = cast(params.smallImageKey, Null<String>);
		presence.smallImageText = cast(params.smallImageText, Null<String>);

		return presence;
	}

	public static function prepare():Void
	{
		if (!initialized)
			DiscordClient.instance.initialize();

		Application.current.onExit.add((_) ->
		{
			if (initialized)
				DiscordClient.instance.shutdown();
		});
	}

	static function handlers_ready(request:RawConstPointer<DiscordUser>):Void
	{
		Print("Discord Client Handler: Connected!");

		final userName:String = request[0].username;
		final globalName:String = request[0].globalName;
		final discriminator:Int = Std.parseInt(request[0].discriminator);
		final nitroType:String = get_nitroToString(request);

		Print('Discord Client Handler: User - ${(discriminator != 0 ? '$globalName#$discriminator' : '@$globalName')} ($userName / $nitroType)');

		DiscordClient.instance.changePresence();
	}

	static function handlers_disconnected(code:Int, msg:ConstCharStar):Void
		Print('Discord Client Handler: Disconnected! ($code:$msg)');

	static function handlers_errored(code:Int, msg:ConstCharStar):Void
		Print('Discord Client Handler: Error! ($code:$msg)');

	static function get_nitroToString(request:RawConstPointer<DiscordUser>):ConstCharStar
	{
		switch (request[0].premiumType)
		{
			case DiscordPremiumType_Nitro:
				return cast("Nitro Full");
			case DiscordPremiumType_NitroBasic:
				return cast("Nitro Basic");
			case DiscordPremiumType_NitroClassic:
				return cast("Nitro Classic");
			default:
				return cast("Without Nitro");
		}
	}

	static function set_clientID(v:String):String
	{
		final changed:Bool = (clientID != v);
		clientID = v;

		if (changed && initialized)
		{
			DiscordClient.instance.shutdown();
			DiscordClient.instance.initialize();
		}

		return v;
	}

	static function get_instance():DiscordClient
	{
		if (DiscordClient._instance == null)
			_instance = new DiscordClient();
		if (DiscordClient._instance == null)
			throw "Could not initialize singleton DiscordClient";
		return DiscordClient._instance;
	}
}

typedef DiscordPresenceParams =
{
	details:Null<String>,
	?state:String,
	?largeImageKey:String,
	?largeImageText:String,
	?smallImageKey:String,
	?smallImageText:String
}
#end
