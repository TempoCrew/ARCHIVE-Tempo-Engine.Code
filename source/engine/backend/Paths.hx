package engine.backend;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static var loader:LoaderPaths;

	public static function image(path:String):String
		return "assets/images/" + path;

	public static function font(file:String):String
		return 'fonts/$file';

	public static function engine(path:String):String
		return "assets/engine/" + path;

	public static function trophies(path:String):String
		return "assets/trophies/" + path;

	public static function embed(file:String):String
	{
		if (file.endsWith('.ogg') || file.endsWith('.mp3'))
			return "embed:assets/embed/sounds/" + file;
		else if (file.endsWith('.png') || file.endsWith('.xml'))
			return "embed:assets/embed/images/" + file;

		return "embed:assets/embed/" + file;
	}
}

class LoaderPaths
{
	public var atlas:AtlasPaths;

	public function image(path:String):BitmapData
	{
		if (!FileSystem.exists(path + '.${Constants.EXT_IMAGE}'))
		{
			trace('Not exists!');
			return null;
		}

		return BitmapData.fromFile(path + '.${Constants.EXT_IMAGE}');
	}

	public function text(path:String):String
	{
		if (!FileSystem.exists(path))
		{
			trace('Not exists!');
			return null;
		}

		return OpenFLAssets.getText(path);
	}
}

class AtlasPaths
{
	public function sparrow(path:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(Paths.loader.image(path), Paths.loader.text(path + '.xml'));
	}
}
