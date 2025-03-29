package engine.backend.util;

import lime.system.Display;
import flixel.util.FlxSignal.FlxTypedSignal;

#if windows
@:buildXml('
<target id="haxe">
  <lib name="wininet.lib" if="windows" />
	<lib name="dwmapi.lib" if="windows" />
</target>
')
@:cppFileCode('
#include <cstdio>
#include <iostream>
#include <tchar.h>
#include <dwmapi.h>
#include <windows.h>
#include <winuser.h>

#pragma comment(lib, "Shell32.lib")

extern "C" HRESULT WINAPI SetCurrentProcessExplicitAppUserModelID(PCWSTR AppID);
')
#elseif linux
@:cppFileCode("
#include <stdio.h>
")
#end
class WindowsUtil
{
	#if windows
	@:functionCode("
		unsigned long long allocatedRAM = 0;
		GetPhysicallyInstalledSystemMemory(&allocatedRAM);

		return (allocatedRAM / 1024);
	")
	#elseif linux
	@:functionCode('
		FILE *meminfo = fopen("/proc/meminfo", "r");

    if(meminfo == NULL)
		return -1;

    char line[256];
    while(fgets(line, sizeof(line), meminfo))
    {
      int ram;
      if(sscanf(line, "MemTotal: %d kB", &ram) == 1)
      {
        fclose(meminfo);
        return (ram / 1024);
      }
    }

    fclose(meminfo);
    return -1;
	')
	#end
	public static function getSystemRAM()
	{
		return 0;
	}

	#if (windows && FEATURE_MAX_DPI_DISPLAY)
	// wait
	public static function setProcessDPIAware():Void
	{
		untyped __cpp__("SetProcessDPIAware();");
		final display:Display = LimeSystem.getDisplay(0);
		if (display != null)
		{
			final dpiScale:Float = display.dpi / Constants.DPI_DIVIDE;
			final _w:Int = Std.int(Constants.SETUP_GAME.width * dpiScale);
			final _h:Int = Std.int(Constants.SETUP_GAME.height * dpiScale);

			Lib.current.stage.application.window.setMaxSize(_w, _h);
		}
	}
	#end

	#if windows
	public static function createProcess(app:String, args:String, hide:Bool = false, waitForTerminate:Bool = false, ?onSuccess:Void->Void,
			?onError:Int->Void):Int
	{
		final result = systools.win.Tools.createProcess(app, args, Sys.getCwd(), hide, waitForTerminate);
		if (result == 0)
		{
			if (onSuccess != null)
				onSuccess();
		}
		else
		{
			if (onError != null)
				onError(result);
		}

		return result;
	}

	@:functionCode('
    int darkMode = mode;
    HWND window = GetActiveWindow();
    if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
        DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
    }
    UpdateWindow(window);
  ') @:noCompletion public static function _setWindowColorMode(mode:Int) {}

	public static function setWindowColorMode(mode:WindowColorMode)
	{
		var darkMode:Int = cast(mode, Int);

		if (darkMode > 1 || darkMode < 0)
		{
			trace("WindowColorMode Not Found...");

			return;
		}

		_setWindowColorMode(darkMode);
	}

	public static function goAheadIco():Void
	{
		FileUtil.createFolderIfNotExist('Resource');

		if (!FileSystem.exists('./Resource/icon.ico') && FileSystem.exists('./icon.ico'))
			FileSystem.rename('./icon.ico', './Resource/icon.ico');
		else if (FileSystem.exists('./Resource/icon.ico') && FileSystem.exists('./icon.ico'))
			FileSystem.deleteFile('icon.ico');
	}
	#end

	public static final windowExit:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();
	public static final windowFocus:FlxTypedSignal<Void->Void> = new FlxTypedSignal<Void->Void>();
	public static final windowUnFocus:FlxTypedSignal<Void->Void> = new FlxTypedSignal<Void->Void>();

	public static function initWindowExitDispatch():Void
		Lib.current.stage.application.onExit.add((c:Int) -> windowExit.dispatch(c));

	public static function initWindowFocusDispatch():Void
		Lib.current.stage.application.window.onFocusIn.add(() -> windowFocus.dispatch());

	public static function initWindowUnFocusDispatch():Void
		Lib.current.stage.application.window.onFocusOut.add(() -> windowUnFocus.dispatch());

	#if FEATURE_DEBUG_TRACY
	public static function initDebugTracy():Void
		Lib.current.stage.addEventListener(Event.EXIT_FRAME, (e:Event) -> cpp.vm.tracy.TracyProfiler.frameMark());
	#end
}

#if windows
enum abstract WindowColorMode(Int) from Int to Int
{
	var DARK = 1;
	var LIGHT = 0;
}
#end
