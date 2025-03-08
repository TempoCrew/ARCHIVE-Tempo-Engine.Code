package engine.backend;

import lime.utils.ArrayBuffer;
import openfl.utils.ByteArray;
import engine.backend.util.SpriteUtil;
import engine.backend.util.MemoryUtil;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static var loader(get, never):LoaderPaths;
	public static var atlas(get, never):AtlasPaths;

	public static function image(id:String, ?library:String):String
		return (library != null ? '$library:' : '') + "assets/" + (library != null ? '$library/' : '') + "images/" + id;

	public static function sound(id:String, ?library:String):String
		return (library != null ? '$library:' : '') + "assets/" + (library != null ? '$library/' : '') + "sounds/" + id;

	public static function music(id:String, ?library:String):String
		return (library != null ? '$library:' : '') + 'assets/${library != null ? '$library/' : ''}music/$id';

	public static function song(name:String, fileName:String):String
		return 'songs:assets/songs/${name.toFolderCase()}/$fileName';

	public static function font(file:String):String
		return 'fonts/$file';

	public static function engine(id:String):String
		return "engine:assets/engine/" + id;

	public static function embed(id:String):String
	{
		if (id.endsWith('.${Constants.EXT_SOUND}'))
			return "embed:assets/embed/sounds/" + id;
		else if (id.endsWith('.png') || id.endsWith('.xml'))
			return "embed:assets/embed/images/" + id;

		return "embed:assets/embed/" + id;
	}

	static var _loader:Null<LoaderPaths> = null;
	static var _atlas:Null<AtlasPaths> = null;

	static function get_loader():LoaderPaths
	{
		if (Paths._loader == null)
			_loader = new LoaderPaths();
		if (Paths._loader == null)
			throw "Could not initialize singleton LoaderPaths!";
		return Paths._loader;
	}

	static function get_atlas():AtlasPaths
	{
		if (Paths._atlas == null)
			_atlas = new AtlasPaths();
		if (Paths._atlas == null)
			throw "Could not initialize singleton AtlasPaths!";
		return Paths._atlas;
	}
}

@:access(openfl.display.BitmapData)
class LoaderPaths
{
	// Constructor
	public function new() {}

	public function image(path:String #if FEATURE_MODS_ALLOWED, ?library:String #else, ?isFromFile:Bool = false #end):FlxGraphic
	{
		if (isFromFile == null)
			isFromFile = false;

		#if !FEATURE_MODS_ALLOWED
		if (!path.contains(':') && isFromFile == false)
		{
			final lePath:String = path;
			path = "preload:" + lePath;
		}
		#end

		final e:String = '.${Constants.EXT_IMAGE}';

		if (path.endsWith(e))
		{
			final lePath:String = path;
			path = lePath.substr(0, lePath.length - e.length);
		}

		final key:String = #if FEATURE_MODS_ALLOWED (library == null ? '$path$e' : '$library:$path$e') #else '$path$e' #end;
		if (MemoryUtil.curTrackedGraphic.exists(key))
		{
			MemoryUtil.localTrackedAssets.push(key);
			return MemoryUtil.curTrackedGraphic.get(key);
		}

		var bitmap:BitmapData = null;
		var isExists:Bool = #if FEATURE_MODS_ALLOWED (library == null ? FileSystem.exists('$path$e') : OpenFLAssets.exists('$library:$path$e',
			IMAGE)) #else (!isFromFile ? OpenFLAssets.exists('$path$e', IMAGE) : FileSystem.exists('$path$e')) #end;

		if (isExists)
			bitmap = (#if (FEATURE_MODS_ALLOWED) library == null #else isFromFile #end ?BitmapData.fromFile('$path$e') : FlxAssets.getBitmapData(#if FEATURE_MODS_ALLOWED '$library:$path$e' #else '$path$e' #end));

		if (bitmap == null)
		{
			trace('Could not load a bitmap! [${key}]');
			return null;
		}

		if (Save.optionsData.cacheVRAM && bitmap.image != null)
			SpriteUtil.disposeBitmap(bitmap);

		final graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;

		MemoryUtil.curTrackedGraphic.set(key, graphic);
		MemoryUtil.localTrackedAssets.push(key);

		trace(path);
		return graphic;
	}

	public function sound(path:String):Sound
	{
		var snd:Sound = null;

		final e:String = '.${Constants.EXT_SOUND}';
		if (path.endsWith(e))
		{
			final lePath:String = path;
			path = lePath.substr(0, lePath.length - e.length);
		}

		try
		{
			if (path.contains(':'))
				snd = FlxAssets.getSound(path + e);
			else
				snd = Sound.fromFile(path + e);
		}
		catch (e:Exception)
			trace("Could not loaded a sound '" + path + "' [" + e.message + "]");

		trace(path);
		return snd;
	}

	public function text(path:String):String
	{
		var txt:String = null;

		try
		{
			if (path.contains(':'))
				txt = OpenFLAssets.getText(path);
			else
				txt = File.getContent(path);
		}
		catch (e:Exception)
			trace('Could not loaded a text file "$path" [${e.message}]');

		trace(path);
		return txt;
	}
}

class AtlasPaths
{
	// Constructor
	public function new() {}

	public function sparrow(path:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(Paths.loader.image(path), Paths.loader.text(path + '.xml'));
	}
}
