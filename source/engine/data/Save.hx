package engine.data;

import engine.backend.util.SysUtil;
import engine.types.SaveTag;
import tempo.util.TempoSave;

// you can write here custom save variables

@:structInit class MainVariables
{
	/**
	 * Level score (1 - level name, 2 - score)
	 */
	public var levelData:Map<String,
		{
			score:Int,
			accuracy:Float,
			rating:String,
			ratingFC:String
		}> = [];

	/**
	 * Song Map Data
	 */
	public var songData:Map<String,
		{
			score:Int,
			accuracy:Float,
			rating:String,
			ratingFC:String
		}> = [];
}

// and here custom options save variables

@:structInit class OptionsVariables
{
	#if FEATURE_DISCORD_RPC
	/**
	 * Discord Rich Presence will showed or not?
	 */
	public var discordRPC:Bool = true;
	#end

	#if web
	/**
	 * Game FPS (Frames per Second)
	 */
	public var framerate:Float = 60;
	#else

	/**
	 * Game FPS (Frames per Second)
	 */
	public var framerate:Float = 144;
	#end

	/**
	 * FPS Counter shows or no?
	 */
	public var fpsCounter:Bool = true;

	#if debug
	/**
	 * RAM Counter shows or no?
	 */
	public var ramCounter:Bool = true;
	#else

	/**
	 * RAM Counter shows or no?
	 */
	public var ramCounter:Bool = false;
	#end

	/**
	 * If it's a game with flashing lights, use that so epileptics can play too!
	 */
	public var flashing:Bool = false;

	/**
	 * If it's a game with shake screen, use that so epileptics can play too!
	 */
	public var shaking:Bool = false;

	#if FEATURE_CHECKING_UPDATE
	/**
	 * This value for checking a git-updates!
	 */
	public var updatesCheck:Bool = true;
	#end

	/**
	 * This game with anti-alias or no? (if pixel game - no)
	 */
	public var antialiasing:Bool = true;

	/**
	 * Note system offset for bluetooth users (and more)
	 */
	public var strumOffset:Float = 0;

	/**
	 * Note in screen middle
	 */
	public var middleScroll:Bool = false;

	/**
	 * Note in screen bottom
	 */
	public var downScroll:Bool = false;

	/**
	 * Screenshot export type (png or jpg)
	 */
	public var screenshotEncoder:String = "png";

	/**
	 * Safe frames for Note system
	 */
	public var safeFrames:Float = 10;

	/**
	 * Show's a opponent strum notes?
	 */
	public var enemyStrums:Bool = true;
}

// here a flixel saves
@:structInit class FlixelVariables
{
	/**
	 * In starting (and not only for that), game will full-screen'ed?
	 */
	public var fullscreen:Bool = false;

	public var muted:Bool = false;

	public var volume:Float = 1.0;
}

@:structInit class EditorVariables
{
	public var bgColor:{r:Int, g:Int, b:Int} = {r: 75, g: 0, b: 130};
}

#if FEATURE_GAMEJOLT_CLIENT
@:structInit class GJVariables
{
	/**
	 * User - `name`
	 */
	public var userName:String = null;

	/**
	 * User - `token`
	 */
	public var userToken:String = null;
}
#end

@:access(tempo.util.TempoSave)
class Save
{
	/**
	 * `Main`, save data.
	 */
	public static var mainData:MainVariables = {};

	/**
	 * `Options`, save data.
	 */
	public static var optionsData:OptionsVariables = {};

	/**
	 * `Flixel`, save data.
	 */
	public static var flixelData:FlixelVariables = {};

	/**
	 * `Editor`, save data.
	 */
	public static var editorData:EditorVariables = {};

	#if FEATURE_GAMEJOLT_CLIENT
	/**
	 * `GameJolt`, save data
	 */
	public static var gjData:GJVariables = {};
	#end

	/**
	 * `Main`, saving stuff.
	 */
	public static var mainSave:TempoSave = new TempoSave();

	/**
	 * `Options`, saving stuff.
	 */
	public static var optionsSave:TempoSave = new TempoSave();

	#if FEATURE_GAMEJOLT_CLIENT
	/**
	 * `GameJolt`, saving stuff.
	 */
	public static var gjSave:TempoSave = new TempoSave();
	#end

	/**
	 * `Editor`, saving stuff.
	 */
	public static var editorSave:TempoSave = new TempoSave();

	/**
	 * `Input`, saving stuff.
	 */
	public static var inputSave:TempoSave = new TempoSave();

	/**
	 * All keyboard binds.
	 *
	 * 1'st - Bind name, 2'nd - Binds List (or one bind)
	 */
	public static var binds_key:Map<String, Array<FlxKey>> = [
		// notes input
		'_strumleft' => [A, LEFT],
		'_strumdown' => [S, DOWN],
		'_strumup' => [W, UP],
		'_strumright' => [D, RIGHT],
		// ui input
		'_uileft' => [A, LEFT],
		'_uidown' => [S, DOWN],
		'_uiup' => [W, UP],
		'_uiright' => [D, RIGHT],
		'_uiaccept' => [ENTER, SPACE],
		'_uiback' => [ESCAPE, BACKSPACE],
		// game input
		'_gamepause' => [ESCAPE, ENTER],
		'_gamereset' => [R],
		// cutscenes input
		'_csaccept' => [Z],
		'_csignore' => [X],
		// other
		'_screenshot' => [F12],
		// freeplay input
		'_fpcharselect' => [TAB],
		'_fpfavorite' => [F],
		'_fpleft' => [Q],
		'_fpright' => [E],
		// ui stuff input
		'_volumemute' => [ZERO],
		'_volumeup' => [PLUS, NUMPADPLUS],
		'_volumedown' => [MINUS, NUMPADMINUS],
		// debugger input
		'_debug_1' => [F8],
		'_debug_2' => [SEVEN],
		'_debug_3' => [EIGHT],
		'_debug_4' => [F4]
	];

	/**
	 * All gamepad binds.
	 *
	 * 1'st - Bind name, 2'nd - Binds List (or one bind)
	 */
	public static var binds_joy:Map<String, Array<FlxGamepadInputID>> = [
		// notes input
		'_strumleft' => [DPAD_LEFT, X],
		'_strumdown' => [DPAD_DOWN, A],
		'_strumup' => [DPAD_UP, Y],
		'_strumright' => [DPAD_RIGHT, B],
		// ui input
		'_uileft' => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'_uidown' => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'_uiup' => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'_uiright' => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		'_uiaccept' => [A, START],
		'_uiback' => [B, BACK],
		// game input
		'_gamepause' => [START],
		'_gamereset' => [BACK],
		// cutscenes input
		'_csaccept' => [RIGHT_TRIGGER],
		'_csignore' => [LEFT_TRIGGER],
		// freeplay input
		'_fpleft' => [LEFT_TRIGGER_BUTTON],
		'_fpright' => [RIGHT_TRIGGER_BUTTON],
	];

	/**
	 * Parent keyboard binds.
	 */
	public static var parentKeys:Map<String, Array<FlxKey>> = null;

	/**
	 * Parent gamepad binds.
	 */
	public static var parentJoyKeys:Map<String, Array<FlxGamepadInputID>> = null;

	/**
	 * Reset binds to default
	 * @param joystick If current driver is gamepad, write here `true`, or `false`, if it keyboard.
	 */
	public static function resetKeysToDefault(?joystick:Null<Bool> = null):Void
	{
		if (joystick != true)
		{
			for (key in binds_key.keys())
				if (parentKeys.exists(key))
					binds_key.set(key, parentKeys.get(key).copy());
		}
		else
		{
			for (key in binds_joy.keys())
				if (parentJoyKeys.exists(key))
					parentJoyKeys.set(key, parentJoyKeys.get(key).copy());
		}
	}

	/**
	 * Reloading `parentkeys` and `parentJoyKeys`.
	 */
	public static function reloadParentKeys():Void
	{
		parentKeys = binds_key.copy();
		parentJoyKeys = binds_joy.copy();
	}

	/**
	 * Removing a invalid keys (`null` and `NONE` value's)
	 * @param key Bind name (from `binds_key` or `binds_joy`).
	 */
	public static function removeInvalidKeys(key:String)
	{
		var bind:Array<Dynamic> = [binds_key.get(key), binds_joy.get(key)];

		while (bind[0] != null && bind[0].contains(FlxKey.NONE))
			bind[0].remove(FlxKey.NONE);

		while (bind[1] != null && bind[1].contains(FlxGamepadInputID.NONE))
			bind[1].remove(FlxGamepadInputID.NONE);
	}

	/**
	 * Reloading a binds for `[User]/AppData/Local/[Company]/[save_tag].save`
	 */
	public static function loadBinds()
	{
		FlxG.save.bind('${SysUtil.getFileName().toFolderCase()}_flixel', _path());
		mainSave.bind('${SysUtil.getFileName().toFolderCase()}_main', _path());
		optionsSave.bind('${SysUtil.getFileName().toFolderCase()}_options', _path());
		editorSave.bind('${SysUtil.getFileName().toFolderCase()}_editor', _path());

		#if FEATURE_GAMEJOLT_CLIENT
		gjSave.bind('${SysUtil.getFileName().toFolderCase()}_gamejolt', _path());
		#end

		inputSave.bind('${SysUtil.getFileName().toFolderCase()}_input_v' + Constants.INPUT_DATA_VERSION, _path());
	}

	/**
	 * Load function for load variables... yes
	 * @param values - If miss this, will loaded all saves
	 * Save Tags: [
	 *    FLIXEL,
	 *    MAIN,
	 *    INPUT,
	 *    OPTIONS,
	 *    GAMEJOLT
	 * ]
	 */
	public static function load(?values:Array<SaveTag> = null)
	{
		if (values == null)
		{
			_load_main();
			_load_options();
			#if FEATURE_GAMEJOLT_CLIENT
			_load_gj();
			#end
			_load_editor();
			_load_input();
			_load_flixel();
		}
		else
		{
			for (value in values)
				switch (value)
				{
					case MAIN:
						_load_main();
					case OPTIONS:
						_load_options();
					#if FEATURE_GAMEJOLT_CLIENT
					case GAMEJOLT:
						_load_gj();
					#end
					case EDITOR:
						_load_editor();
					case INPUT:
						_load_input();
					default:
						_load_flixel();
				}
		}
	}

	/**
	 * Save function for save variables... yes
	 * @param values - If miss this, will saved all saves
	 * Save Tags: [
	 *    FLIXEL,
	 *    MAIN,
	 *    INPUT,
	 *    OPTIONS,
	 *    GAMEJOLT
	 * ]
	 */
	public static function save(?values:Array<SaveTag> = null)
	{
		if (values == null)
		{
			_save_main();
			_save_options();
			#if FEATURE_GAMEJOLT_CLIENT
			_save_gj();
			#end
			_save_editor();
			_save_flixel();
			_save_input();
		}
		else
		{
			for (value in values)
				switch (value)
				{
					case MAIN:
						_save_main();
					case OPTIONS:
						_save_options();
					#if FEATURE_GAMEJOLT_CLIENT
					case GAMEJOLT:
						_save_gj();
					#end
					case EDITOR:
						_save_editor();
					case INPUT:
						_save_input();
					default:
						_save_flixel();
				}
		}
	}

	public static function mergeData(v:{tag:SaveTag, value:Dynamic}):Void
	{
		switch (v.tag)
		{
			case MAIN:
				for (key in Reflect.fields(mainData))
					if (Reflect.hasField(v.value, key))
						Reflect.setField(mainData, key, Reflect.field(v.value, key));

				save([MAIN]);
			case OPTIONS:
				for (key in Reflect.fields(optionsData))
					if (Reflect.hasField(v.value, key))
						Reflect.setField(optionsData, key, Reflect.field(v.value, key));

				save([OPTIONS]);
			case FLIXEL:
				for (key in Reflect.fields(flixelData))
					if (Reflect.hasField(v.value, key))
						Reflect.setField(flixelData, key, Reflect.field(v.value, key));

				save([FLIXEL]);
			case GAMEJOLT:
				for (key in Reflect.fields(gjData))
					if (Reflect.hasField(v.value, key))
						Reflect.setField(gjData, key, Reflect.field(v.value, key));

				save([GAMEJOLT]);

			case EDITOR:
				for (key in Reflect.fields(editorData))
					if (Reflect.hasField(v.value, key))
						Reflect.setField(editorData, key, Reflect.field(v.value, key));
			default: // nothing
		}
	}

	/**
	 * Returning a path for `loadBinds()` function.
	 */
	inline static function _path():String
		return '${openfl.Lib.application.meta['company']}/${flixel.util.FlxSave.validate(openfl.Lib.application.meta['file'])}';

	static function _load_main():Void
	{
		if (mainSave != null && mainSave.data != null)
		{
			for (key in Reflect.fields(mainData))
				if (Reflect.hasField(mainSave.data, key))
					Reflect.setField(mainData, key, Reflect.field(mainSave.data, key));
		}
	}

	static function _load_options():Void
	{
		if (optionsSave != null && optionsSave.data != null)
		{
			for (key in Reflect.fields(optionsData))
				if (Reflect.hasField(optionsSave.data, key))
					Reflect.setField(optionsData, key, Reflect.field(optionsSave.data, key));
		}
	}

	#if FEATURE_GAMEJOLT_CLIENT
	static function _load_gj():Void
	{
		if (gjSave.data != null && gjSave != null)
		{
			for (key in Reflect.fields(gjData))
				if (Reflect.hasField(gjSave.data, key))
					Reflect.setField(gjData, key, Reflect.field(gjSave.data, key));
		}
	}
	#end

	static function _load_editor():Void
	{
		if (editorSave.data != null && editorSave != null)
		{
			for (key in Reflect.fields(editorData))
				if (Reflect.hasField(editorSave.data, key))
					Reflect.setField(editorData, key, Reflect.field(editorSave.data, key));
		}
	}

	static function _load_input():Void
	{
		if (inputSave.data != null && inputSave != null)
		{
			if (inputSave.data.keyboard != null)
			{
				var parentKeys:Map<String, Array<flixel.input.keyboard.FlxKey>> = inputSave.data.keyboard;
				for (key => keys in parentKeys)
					if (binds_key.exists(key))
						binds_key.set(key, keys);
			}

			if (inputSave.data.joystick != null)
			{
				var parentKeys:Map<String, Array<flixel.input.gamepad.FlxGamepadInputID>> = inputSave.data.joystick;
				for (key => keys in parentKeys)
					if (binds_joy.exists(key))
						binds_joy.set(key, keys);
			}
		}
	}

	static function _load_flixel():Void
	{
		for (key in Reflect.fields(flixelData))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(flixelData, key, Reflect.field(FlxG.save.data, key));

		FlxG.sound.volume = flixelData.volume;
		FlxG.sound.muted = flixelData.muted;
	}

	static function _save_main():Void
	{
		if (mainData != null)
		{
			for (key in Reflect.fields(mainData))
				Reflect.setField(mainSave.data, key, Reflect.field(mainData, key));
		}
	}

	static function _save_options():Void
	{
		if (optionsData != null)
		{
			for (key in Reflect.fields(optionsData))
				Reflect.setField(optionsSave.data, key, Reflect.field(optionsData, key));
		}
	}

	#if FEATURE_GAMEJOLT_CLIENT
	static function _save_gj():Void
	{
		if (gjData != null)
		{
			for (key in Reflect.fields(gjData))
				Reflect.setField(gjSave.data, key, Reflect.field(gjData, key));
		}
	}
	#end

	static function _save_editor():Void
	{
		if (editorData != null)
		{
			for (key in Reflect.fields(editorData))
				Reflect.setField(editorSave.data, key, Reflect.field(editorData, key));
		}
	}

	static function _save_flixel():Void
	{
		for (key in Reflect.fields(flixelData))
			Reflect.setField(FlxG.save.data, key, Reflect.field(flixelData, key));

		FlxG.save.flush();

		FlxG.sound.volume = FlxG.save.data.volume;
		FlxG.sound.muted = FlxG.save.data.muted;
	}

	static function _save_input():Void
	{
		if (inputSave.data != null)
		{
			inputSave.data.keyboard = binds_key;
			inputSave.data.joystick = binds_joy;
		}
	}
}
