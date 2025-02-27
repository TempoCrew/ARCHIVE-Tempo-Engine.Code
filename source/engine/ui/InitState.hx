package engine.ui;

import engine.backend.api.GameJoltClient;
import engine.backend.api.DiscordClient;

class InitState extends flixel.FlxState
{
	override function create():Void
	{
		#if FEATURE_GAMEJOLT_CLIENT
		Save.load([GAMEJOLT]);

		new FlxTimer().start(1, (_) ->
		{
			GameJoltClient.instance.initialize();
		});
		#end

		new FlxTimer().start(2, (_) ->
		{
			Thread.create(() ->
			{
				Save.load([MAIN, OPTIONS, INPUT, FLIXEL, EDITOR]);
			});
		});

		super.create();

		#if FEATURE_DISCORD_RPC
		DiscordClient.prepare();
		#end

		new FlxTimer().start(#if FEATURE_GAMEJOLT_CLIENT 3 #else 1 #end, (t:FlxTimer) ->
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
