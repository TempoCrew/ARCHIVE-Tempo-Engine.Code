package engine.backend;

import engine.backend.util.log.CrashLog;

class Setup
{
	public static function create():Void
	{
		FlxSprite.defaultAntialiasing = true;

		FlxG.save.bind('tempo');

		Main.instance.addChild(tempo.TempoGame.setup(Constants.SETUP_GAME.width, Constants.SETUP_GAME.height, Constants.SETUP_GAME.initialState,
			Constants.SETUP_GAME.zoom, Constants.SETUP_GAME.framerate, Constants.SETUP_GAME.skipSplash, Constants.SETUP_GAME.startFullScreen));

		CrashLog.init();
	}
}
