package engine.backend.macro;

#if FEATURE_GAMEJOLT_CLIENT
class GameJoltMacro
{
	static macro function getData():haxe.macro.Expr.ExprOf<{ID:Int, Key:String}>
	{
		#if !display
		return macro $v{formatData()};
		#else
		return macro $v{{ID: 0, Key: ""}};
		#end
	}

	#if (macro)
	@SuppressWarnings('checkstyle:Dynamic')
	static function formatData():{ID:Int, Key:String}
	{
		return cast haxe.Json.parse(sys.io.File.getContent('gamejolt.json'));
	}
	#end
}
#end
