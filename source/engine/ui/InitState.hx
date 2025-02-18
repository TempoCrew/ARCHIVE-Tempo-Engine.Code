package engine.ui;

import engine.backend.api.GameJoltClient;
import engine.backend.api.DiscordClient;

class InitState extends flixel.FlxState
{
	override function create():Void
	{
		Save.load();

		super.create();

		FlxG.sound.muted = Save.otherData.muted;
		FlxG.sound.volume = Save.otherData.volume;

		#if FEATURE_DISCORD_RPC
		DiscordClient.prepare();
		#end

		GameJoltClient.instance.initialize();

		new FlxTimer().start(1, (t:FlxTimer) ->
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
