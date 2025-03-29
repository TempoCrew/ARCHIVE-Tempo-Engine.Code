package engine;

import engine.objects.Counters;

class Setup
{
	#if desktop
	public static var counters:Array<Counters> = [];
	#end

	static function create():Void
	{
		FlxSprite.defaultAntialiasing = true;

		Save.loadBinds();

		#if desktop
		createCounters();
		#end

		#if FEATURE_DEBUG_TRACY
		engine.backend.util.WindowsUtil.initDebugTracy();
		#end

		engine.backend.util.WindowsUtil.initWindowFocusDispatch();
		engine.backend.util.WindowsUtil.initWindowUnFocusDispatch();

		engine.backend.util.WindowsUtil.initWindowExitDispatch();

		tempo.util.TempoSystem.get_OS_info();

		#if FEATURE_VIDEO_PLAYBACK
		hxvlc.util.Handle.init(['--no-lua']);
		#end

		#if FEATURE_LUA_SCRIPTING
		llua.Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(_lua_call));
		#end

		engine.backend.util.plugins.CrashPlugin.init();

		#if FEATURE_SMOOTH_UNFOCUS_MUSIC
		engine.backend.util.SoundUtil.initUnFocusVol();
		#end

		Main.instance.addChild(tempo.TempoGame.setup(Constants.SETUP_GAME.width, Constants.SETUP_GAME.height, Constants.SETUP_GAME.initialState,
			Constants.SETUP_GAME.zoom, Constants.SETUP_GAME.framerate, Constants.SETUP_GAME.skipSplash, Constants.SETUP_GAME.startFullScreen));

		#if desktop
		for (c in counters)
			Main.instance.addChild(c);
		#end
	}

	#if desktop
	@:noUsing static function createCounters():Void
	{
		for (i in 0...5)
		{
			final constParams = {
				x: (i == 0 || i == 2) ? Constants.COUNTER_POS.x + 1 : (i == 1 || i == 3) ? Constants.COUNTER_POS.x - 1 : Constants.COUNTER_POS.x,
				y: (i == 0 || i == 1) ? Constants.COUNTER_POS.y - 1 : (i == 2 || i == 3) ? Constants.COUNTER_POS.y + 1 : Constants.COUNTER_POS.y,
				c: (i == 4) ? Constants.COUNTER_COLOR : Constants.COUNTER_BACK_COLOR
			};

			final newCounter:Counters = new Counters(constParams.x, constParams.y, constParams.c);
			counters.push(newCounter);
		}
	}
	#end

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
