package engine.backend;

import cpp.Callable;
import engine.backend.util.log.CrashLog;

class Setup
{
	static function create():Void
	{
		FlxSprite.defaultAntialiasing = true;

		#if FEATURE_VIDEO_PLAYBACK
		hxvlc.util.Handle.init(['--no-lua']);
		#end

		#if FEATURE_LUA_SCRIPTING
		Lua.set_callbacks_function(Callable.fromStaticFunction(_lua_call));
		#end

		Save.loadBinds();

		Main.instance.addChild(tempo.TempoGame.setup(Constants.SETUP_GAME.width, Constants.SETUP_GAME.height, Constants.SETUP_GAME.initialState,
			Constants.SETUP_GAME.zoom, Constants.SETUP_GAME.framerate, Constants.SETUP_GAME.skipSplash, Constants.SETUP_GAME.startFullScreen));

		CrashLog.init();
	}

	// IGNORE THIS
	static inline function _lua_call(l:LuaState, fname:String):Int
	{
		try
		{
			var cbf:Dynamic = Lua_helper.callbacks.get(fname);
			if (cbf == null)
			{
				// Waiting a TempoLua will added and writed a code...
			}

			if (cbf == null)
				return 0;

			var nparams:Int = Lua.gettop(l);
			var args:Array<Dynamic> = [];

			for (i in 0...nparams)
			{
				args[i] = LuaConvert.fromLua(l, i + 1);
			}

			var ret:Dynamic = null;
			ret = Reflect.callMethod(null, cbf, args);

			if (ret != null)
			{
				LuaConvert.toLua(l, ret);
				return 1;
			}
		}
		catch (e:Exception)
		{
			if (Lua_helper.sendErrorsToLua)
			{
				LuaL.error(l, 'CALLBACK ERROR! ${e.details()}');
				return 0;
			}
			throw e;
		}
		return 0;
	}
}
