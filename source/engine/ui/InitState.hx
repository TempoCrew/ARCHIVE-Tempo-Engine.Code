package engine.ui;

import engine.backend.api.GameJoltClient;
import engine.backend.api.DiscordClient;

class InitState extends flixel.FlxState
{
	override function create():Void
	{
		#if FEATURE_GAMEJOLT_DATA_STORAGE
		Save.load(GAMEJOLT);

		Sys.sleep(1);

		GameJoltClient.instance.initialize();

		Sys.sleep(1);
		#end

		new FlxTimer().start(1, (_) ->
		{
			Thread.create(() ->
			{
				Save.load();

				FlxG.sound.muted = Save.otherData.muted;
				FlxG.sound.volume = Save.otherData.volume;
			});
		});

		super.create();

		#if FEATURE_DISCORD_RPC
		DiscordClient.prepare();
		#end

		new FlxTimer().start(#if FEATURE_GAMEJOLT_DATA_STORAGE 3 #else 1 #end, (t:FlxTimer) ->
		{
			t = null;

			FlxG.switchState(new funkin.ui.menus.TitleState());
		});
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
