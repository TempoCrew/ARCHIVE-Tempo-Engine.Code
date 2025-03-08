package engine;

import engine.backend.util.WindowsUtil;

class Setup
{
	static function create():Void
	{
		#if FEATURE_DEBUG_TRACY
		WindowsUtil.initDebugTracy();
		#end

		WindowsUtil.initWindowExitDispatch();

		flixel.FlxSprite.defaultAntialiasing = true;

		#if FEATURE_VIDEO_PLAYBACK
		hxvlc.util.Handle.init(['--no-lua']);
		#end

		#if FEATURE_LUA_SCRIPTING
		llua.Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(_lua_call));
		#end

		engine.backend.util.plugins.CrashPlugin.init();

		engine.data.Save.loadBinds();

		Main.instance.addChild(tempo.TempoGame.setup(Constants.SETUP_GAME.width, Constants.SETUP_GAME.height, Constants.SETUP_GAME.initialState,
			Constants.SETUP_GAME.zoom, Constants.SETUP_GAME.framerate, Constants.SETUP_GAME.skipSplash, Constants.SETUP_GAME.startFullScreen));
	}

	// IGNORE THIS
	static inline function _lua_call(l:LuaState, fname:String):Int
	{
		try
		{
			var cbf:Dynamic = llua.Lua.Lua_helper.callbacks.get(fname);
			if (cbf == null)
			{
				// Waiting a TempoLua will added and writed a code...
			}

			if (cbf == null)
				return 0;

			var nparams:Int = llua.Lua.gettop(l);
			var args:Array<Dynamic> = [];

			for (i in 0...nparams)
				args[i] = llua.Convert.fromLua(l, i + 1);

			var ret:Dynamic = null;
			ret = Reflect.callMethod(null, cbf, args);

			if (ret != null)
			{
				llua.Convert.toLua(l, ret);
				return 1;
			}
		}
		catch (e:Exception)
		{
			if (llua.Lua.Lua_helper.sendErrorsToLua)
			{
				llua.LuaL.error(l, 'CALLBACK ERROR! ${e.details()}');
				return 0;
			}

			throw e.message;
		}
		return 0;
	}
}
