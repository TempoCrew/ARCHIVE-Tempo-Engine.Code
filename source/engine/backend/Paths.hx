package engine.backend;

class Paths
{
	public static function font(file:String):String
		return 'fonts/$file';

	public static function embed(file:String):String
	{
		if (file.endsWith('.ogg') || file.endsWith('.mp3'))
			return "embed:assets/embed/sounds/" + file;
		else if (file.endsWith('.png') || file.endsWith('.xml'))
			return "embed:assets/embed/images/" + file;

		return "embed:assets/embed/" + file;
	}
}
