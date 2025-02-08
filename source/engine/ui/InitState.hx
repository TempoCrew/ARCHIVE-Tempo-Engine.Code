package engine.ui;

import engine.backend.api.GameJoltClient;
import engine.backend.api.DiscordClient;

class InitState extends flixel.FlxState
{
	override function create():Void
	{
		super.create();

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

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
