package engine.ui.debug.helpers;

class FileHelper
{
	public static function songExists(name:String, file:String):Bool
	{
		return OpenFLAssets.exists(Paths.song(name, '${file}.ogg'), SOUND);
	}
}
