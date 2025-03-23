package tempo;

import engine.data.PlayerSettings;
import funkin.ui.system.TransitionSubState;
#if FEATURE_GAMEJOLT_CLIENT
import gamejolt.formats.User;
#end

class TempoState extends flixel.FlxState
{
	public static var fadeIn:Bool = false;
	public static var camFade:FlxCamera;

	public var player1(get, never):PlayerSettings;
	public var player2(get, never):PlayerSettings;

	override function create():Void
	{
		if (fadeIn)
		{
			if (camFade == null)
			{
				camFade = new FlxCamera();
				camFade.bgColor.alpha = 0;
				FlxG.cameras.add(camFade, false);
			}

			FlxG.state.persistentUpdate = FlxG.state.persistentDraw = true;
			FlxG.state.openSubState(new TransitionSubState(false, Constants.TRANSITION_DURATION, () ->
			{
				fadeIn = false;
				camFade = null;
			}, camFade));
		}

		super.create();
	}

	public static function switchState(nextState:flixel.FlxState, ?onCallback:Void->Void):Void
	{
		if (camFade == null)
		{
			camFade = new FlxCamera();
			camFade.bgColor.alpha = 0;
			FlxG.cameras.add(camFade, false);
		}

		fadeIn = true;
		var transitionSubState:TempoSubState = new TransitionSubState(true, Constants.TRANSITION_DURATION, () ->
		{
			FlxG.state.persistentUpdate = false;
			if (onCallback != null)
				onCallback();

			camFade = null;
			FlxG.switchState(() -> nextState);
		}, camFade);
		FlxG.state.openSubState(transitionSubState);
	}

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
