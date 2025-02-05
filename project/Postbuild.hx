package project;

/**
 * A script which executes after the game is built.
 */
class Postbuild
{
	static inline final BUILD_TIME_FILE:String = '.time';

	static function main():Void
	{
		printBuildTime();
	}

	static function printBuildTime():Void
	{
		#if sys
		var end:Float = Sys.time();
		if (sys.FileSystem.exists(BUILD_TIME_FILE))
		{
			var fi:sys.io.FileInput = sys.io.File.read(BUILD_TIME_FILE);
			var start:Float = fi.readDouble();
			fi.close();

			sys.FileSystem.deleteFile(BUILD_TIME_FILE);

			var buildTime:Float = roundToTwoDecimals(end - start);
			var text:String = '|BUILD TOOK: ${buildTime} SECONDS|';
			var sy:String = '';

			for (i in 0...text.length)
				sy += '=';

			Sys.println('\n$sy\n$text\n$sy\n');
		}
		#end
	}

	static function roundToTwoDecimals(value:Float):Float
	{
		return Math.round(value * 100) / 100;
	}
}
