#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if (linux && !debug)
@:cppInclude('./engine/external/gamemode_client.h')
@:cppFileCode('#define GAMEMODE_AUTO')
#end
#if windows
@:buildXml('
<target id="haxe">
  <lib name="wininet.lib" if="windows" />
	<lib name="dwmapi.lib" if="windows" />
</target>
')
@:cppFileCode('
#include <windows.h>
#include <winuser.h>
#pragma comment(lib, "Shell32.lib")
extern "C" HRESULT WINAPI SetCurrentProcessExplicitAppUserModelID(PCWSTR AppID);
')
#end
class Main extends Sprite
{
	public static var instance:Main;

	static function main():Void
		Lib.current.addChild(new Main());

	function new()
	{
		super();

		#if windows
		untyped __cpp__("SetProcessDPIAware();");
		final display:lime.system.Display = LimeSystem.getDisplay(0);
		if (display != null)
		{
			final dpiScale:Float = display.dpi / Constants.DPI_DIVIDE;
			Lib.application.window.width = Std.int(Constants.SETUP_GAME.width * dpiScale);
			Lib.application.window.height = Std.int(Constants.SETUP_GAME.height * dpiScale);
		}
		#end

		#if desktop
		@:privateAccess
		engine.backend.util.SysUtil.__alsoft__init__();
		#end

		engine.backend.util.SysUtil.findPath();

		instance = this;

		var _init:(?e:Event) -> Void;
		_init = (?e:Event) ->
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, _init);

			@:privateAccess
			engine.backend.Setup.create();
		}

		if (stage == null)
			addEventListener(Event.ADDED_TO_STAGE, _init);
		else
			_init();
	}
}
