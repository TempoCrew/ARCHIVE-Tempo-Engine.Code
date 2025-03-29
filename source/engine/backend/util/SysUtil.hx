package engine.backend.util;

#if windows
import systools.Dialogs;
#end

class SysUtil
{
	public static inline function getFileName():String
		return (Lib.application.meta.get('file') != null ? Lib.application.meta.get('file') : "Tempo Engine");

	#if windows
	public static function message(title:String, description:String, isError:Bool = false):Void
		return Dialogs.message(title, description, isError);

	public static function confirm(title:String, description:String, isError:Bool = false):Bool
		return Dialogs.confirm(title, description, isError);
	#end

	#if desktop
	@:keep static function __alsoft__init__():Void
	{
		FileUtil.createFolderIfNotExist("./plugins/");

		if (!FileSystem.exists('./plugins/alsoft.' + #if windows "ini" #else "conf" #end))
		{
			#if windows
			File.saveContent("./plugins/alsoft.ini", Constants.ALSOFT_DATA);
			#elseif mac
			File.saveContent("./plugins/alsoft.conf", Constants.ALSOFT_DATA);
			#else
			File.saveContent("./plugins/alsoft.conf", Constants.ALSOFT_DATA);
			#end
		}

		final o:String = #if hl Sys.getCwd() #else Sys.programPath() #end;

		var c:String = haxe.io.Path.directory(haxe.io.Path.withoutExtension(o));
		#if windows
		c += "/plugins/alsoft.ini";
		#elseif mac
		c += haxe.io.Path.directory(c) + "/Resources/plugins/alsoft.conf";
		#else
		c += "/plugins/alsoft.conf";
		#end

		Sys.putEnv("ALSOFT_CONF", c);
	}
	#end

	public static function setFeatures():Void
	{
		#if desktop
		@:privateAccess
		engine.backend.util.SysUtil.__alsoft__init__();

		#if !FEATURE_RESIZE_WINDOW
		Lib.current.stage.window.application.window.resizable = false;
		#end

		#if windows
		#if FEATURE_DARK_WINDOW
		WindowsUtil.setWindowColorMode(DARK);
		#else
		WindowsUtil.setWindowColorMode(LIGHT);
		#end
		#if FEATURE_MAX_DPI_DISPLAY
		WindowsUtil.setProcessDPIAware();
		#end
		#end
		#end
	}

	public static function findPath():Void
	{
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(LimeSystem.applicationStorageDirectory);
		#end
	}
}
