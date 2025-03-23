package engine.ui;

import engine.input.Cursor;
import engine.backend.api.GameJoltClient;
import engine.backend.api.DiscordClient;
import engine.backend.util.plugins.*;

class InitState extends flixel.FlxState
{
	override function create():Void
	{
		#if FEATURE_GAMEJOLT_CLIENT
		Save.load([GAMEJOLT]);

		new FlxTimer().start(0.4, (_) ->
		{
			GameJoltClient.instance.initialize();
		});
		#end

		new FlxTimer().start(.8, (_) ->
		{
			Thread.create(() ->
			{
				Save.load([MAIN, OPTIONS, INPUT, FLIXEL, EDITOR]);
			});
		});

		super.create();

		// Plugins
		EvacuatePlugin.initialize();
		ShaderFixPlugin.initialize();
		ScreenshotPlugin.initialize();

		#if FEATURE_DISCORD_RPC
		DiscordClient.prepare();
		#end

		Cursor.cursorMode = Default;
		Cursor.hide();

		new FlxTimer().start(#if FEATURE_GAMEJOLT_CLIENT 1.65 #else 1 #end, (t:FlxTimer) ->
		{
			t = null;

			FlxG.switchState(new WarningState());
		});
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
