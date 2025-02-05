package project;

/**
 * A script which executes before the game is built.
 */
class Prebuild
{
	static function main():Void
	{
		#if sys
		var fo:sys.io.FileOutput = sys.io.File.write('.time');
		var now:Float = Sys.time();
		fo.writeDouble(now);
		fo.close();

		Sys.println('\n=============\n|BUILDING...|\n=============\n');
		#end
	}
}
