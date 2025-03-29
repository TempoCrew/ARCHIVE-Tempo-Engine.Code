package funkin.ui.menus;

class CreditsState extends MusicBeatState
{
	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Credits Menu"});
		#end

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
