package tempo;

import engine.data.PlayerSettings;
#if FEATURE_GAMEJOLT_CLIENT
import gamejolt.formats.User;
#end

class TempoSubState extends flixel.FlxSubState
{
	public var player1(get, never):PlayerSettings;
	public var player2(get, never):PlayerSettings;

	function get_player1():PlayerSettings
	{
		#if FEATURE_GAMEJOLT_CLIENT
		final path:String = Constants.GAMEJOLT_DATA_FILE_PATH;
		final user = TJSON.parse(File.getContent(path)).users[0];
		final id:Int = (FileSystem.exists(path) ? Std.parseInt(user != null ? user.id : "0") : 0);
		#else
		final id:Int = 0;
		#end

		return new PlayerSettings(id);
	}

	function get_player2():PlayerSettings
	{
		#if FEATURE_GAMEJOLT_CLIENT
		final path:String = Constants.GAMEJOLT_DATA_FILE_PATH;
		final user = TJSON.parse(File.getContent(path)).users[1];
		final id:Int = (FileSystem.exists(path) ? Std.parseInt(user != null ? user.id : "1") : 1);
		#else
		final id:Int = 1;
		#end

		return new PlayerSettings(id);
	}
}
