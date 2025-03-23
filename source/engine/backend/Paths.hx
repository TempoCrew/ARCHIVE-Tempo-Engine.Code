package engine.backend;

import lime.media.AudioSource;
import lime.utils.ArrayBuffer;
import openfl.utils.ByteArray;
import engine.backend.util.SpriteUtil;
import engine.backend.util.MemoryUtil;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static var loader(get, never):LoaderPaths;
	public static var atlas(get, never):AtlasPaths;

	public static function image(id:String, ?library:String, ?withoutExtension:Bool = true):String
	{
		if (!id.contains('.') && !withoutExtension)
		{
			final l:String = id;
			id = l + '.${Constants.EXT_IMAGE}';
		}

		return (library != null ? '$library:' : '') + "assets/" + (library != null ? '$library/' : '') + "images/" + id;
	}

	public static function sound(id:String, ?library:String, ?withoutExtension:Bool = true):String
	{
		if (!id.contains('.') && !withoutExtension)
		{
			final l = id;
			id = l + '.${Constants.EXT_SOUND}';
		}

		return (library != null ? '$library:' : '') + "assets/" + (library != null ? '$library/' : '') + "sounds/" + id;
	}

	public static function music(id:String, ?library:String, ?withoutExtension:Bool = true):String
	{
		if (!id.contains('.') && !withoutExtension)
		{
			final l = id;
			id = l + '.${Constants.EXT_SOUND}';
		}

		return (library != null ? '$library:' : '') + 'assets/${library != null ? '$library/' : ''}music/$id';
	}

	public static function song(name:String, fileName:String, ?withoutExtension:Bool = true):String
	{
		if (!fileName.contains('.') && !withoutExtension)
		{
			final l = fileName;
			fileName = l + '.${Constants.EXT_SOUND}';
		}

		return 'songs:assets/songs/${name.toFolderCase()}/$fileName';
	}

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

		final key:String = #if FEATURE_MODS_ALLOWED (library == null ? '$path' : '$library:$path') #else '$path' #end;
		if (MemoryUtil.curTrackedGraphic.exists(key))
		{
			MemoryUtil.localTrackedAssets.push(key);
			return MemoryUtil.curTrackedGraphic.get(key);
		}

		var bitmap:BitmapData = null;
		var isExists:Bool = #if FEATURE_MODS_ALLOWED (library == null ? FileSystem.exists('$path') : OpenFLAssets.exists('$library:$path',
			IMAGE)) #else (!isFromFile ? OpenFLAssets.exists('$path', IMAGE) : FileSystem.exists('$path')) #end;

		if (isExists)
			bitmap = (#if (FEATURE_MODS_ALLOWED) library == null #else isFromFile #end ?BitmapData.fromFile('$path') : FlxAssets.getBitmapData(#if FEATURE_MODS_ALLOWED '$library:$path' #else '$path' #end));

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

		return graphic;
	}

	public function sound(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFromFile:Bool = false #end):Sound
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

		final key:String = #if FEATURE_MODS_ALLOWED (library == null ? '$path' : '$library:$path') #else '$path' #end;
		if (MemoryUtil.curTrackedSound.exists(key))
		{
			MemoryUtil.localTrackedAssets.push(key);
			return MemoryUtil.curTrackedSound.get(key);
		}

		var snd:Sound = null;
		var isExists:Bool = #if FEATURE_MODS_ALLOWED (library == null ? FileSystem.exists('$path') : OpenFLAssets.exists('$library:$path',
			SOUND)) #else (!isFromFile ? OpenFLAssets.exists('$path', SOUND) : FileSystem.exists('$path')) #end;

		if (isExists)
			snd = (#if (FEATURE_MODS_ALLOWED) library == null #else isFromFile #end ?Sound.fromFile('$path') : OpenFLAssets.getSound(#if FEATURE_MODS_ALLOWED '$library:$path' #else '$path' #end,
				true));

		if (snd == null)
		{
			trace('Could not load a sound! ${key}');
			return null;
		}

		if (Save.optionsData.cacheVRAM)
			engine.backend.util.SoundUtil.disposeSound(snd);

		MemoryUtil.curTrackedSound.set(key, snd);
		MemoryUtil.localTrackedAssets.push(key);

		return snd;
	}

	public function text(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFromFile:Bool = false #end):String
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

		final key:String = #if FEATURE_MODS_ALLOWED (library == null ? '$path' : '$library:$path') #else '$path' #end;

		var txt:String = null;
		var isExists:Bool = #if FEATURE_MODS_ALLOWED (library == null ? FileSystem.exists('$path') : OpenFLAssets.exists('$library:$path',
			TEXT)) #else (!isFromFile ? OpenFLAssets.exists('$path', TEXT) : FileSystem.exists('$path')) #end;

		if (isExists)
			txt = #if FEATURE_MODS_ALLOWED (library != null ? OpenFLAssets.getText(key) : File.getContent(key)) #else (isFromFile ? File.getContent(key) : OpenFLAssets.getText(key)) #end;

		if (txt == null)
		{
			trace('Could not loaded a text file "$key" [NULL]');
			return "";
		}

		return txt;
	}
}

class AtlasPaths
{
	// Constructor
	public function new() {}

	public function sparrow(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFilePath:Bool = false #end):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(Paths.loader.image(path + '.png', #if FEATURE_MODS_ALLOWED library #else isFilePath #end),
			Paths.loader.text(path + '.xml', #if FEATURE_MODS_ALLOWED library #else isFilePath #end));
	}

	public function aseprite(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFilePath:Bool = false #end):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromAseprite(Paths.loader.image(path + '.png', #if FEATURE_MODS_ALLOWED library #else isFilePath #end),
			Paths.loader.text(path + '.json', #if FEATURE_MODS_ALLOWED library #else isFilePath #end));
	}

	public function packerXml(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFilePath:Bool = false #end):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromTexturePackerXml(Paths.loader.image(path + '.png', #if FEATURE_MODS_ALLOWED library #else isFilePath #end),
			Paths.loader.text(path + '.xml', #if FEATURE_MODS_ALLOWED library #else isFilePath #end));
	}

	public function sheetPacker(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFilePath:Bool = false #end):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(Paths.loader.image(path + '.png', #if FEATURE_MODS_ALLOWED library #else isFilePath #end),
			Paths.loader.text(path + '.txt', #if FEATURE_MODS_ALLOWED library #else isFilePath #end));
	}

	public function packerJson(path:String, #if FEATURE_MODS_ALLOWED ?library:String #else ?isFilePath:Bool = false #end):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromTexturePackerJson(Paths.loader.image(path + '.png', #if FEATURE_MODS_ALLOWED library #else isFilePath #end),
			Paths.loader.text(path + '.json', #if FEATURE_MODS_ALLOWED library #else isFilePath #end));
	}
}
