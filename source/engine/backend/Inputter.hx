package engine.backend;

class Inputter
{
	// NOTE KEYS

	/**
	 * Note press `UP`
	 */
	public var STRUM_UP_P(get, never):Bool;

	function get_STRUM_UP_P()
		return _justPress('_strumup');

	/**
	 * Note press `DOWN`
	 */
	public var STRUM_DOWN_P(get, never):Bool;

	function get_STRUM_DOWN_P()
		return _justPress('_strumdown');

	/**
	 * Note press `LEFT`
	 */
	public var STRUM_LEFT_P(get, never):Bool;

	function get_STRUM_LEFT_P()
		return _justPress('_strumleft');

	/**
	 * Note press `RIGHT`
	 */
	public var STRUM_RIGHT_P(get, never):Bool;

	function get_STRUM_RIGHT_P()
		return _justPress('_strumright');

	/**
	 * Note pressed `UP`
	 */
	public var STRUM_UP(get, never):Bool;

	function get_STRUM_UP()
		return _pressed('_strumup');

	/**
	 * Note pressed `DOWN`
	 */
	public var STRUM_DOWN(get, never):Bool;

	function get_STRUM_DOWN()
		return _pressed('_strumdown');

	/**
	 * Note pressed `LEFT`
	 */
	public var STRUM_LEFT(get, never):Bool;

	function get_STRUM_LEFT()
		return _pressed('_strumleft');

	/**
	 * Note pressed `RIGHT`
	 */
	public var STRUM_RIGHT(get, never):Bool;

	function get_STRUM_RIGHT()
		return _pressed('_strumright');

	/**
	 * Note released `UP`
	 */
	public var STRUM_UP_R(get, never):Bool;

	function get_STRUM_UP_R()
		return _justReleased('_strumup');

	/**
	 * Note released `DOWN`
	 */
	public var STRUM_DOWN_R(get, never):Bool;

	function get_STRUM_DOWN_R()
		return _justReleased('_strumdown');

	/**
	 * Note released `LEFT`
	 */
	public var STRUM_LEFT_R(get, never):Bool;

	function get_STRUM_LEFT_R()
		return _justReleased('_strumleft');

	/**
	 * Note released `RIGHT`
	 */
	public var STRUM_RIGHT_R(get, never):Bool;

	function get_STRUM_RIGHT_R()
		return _justReleased('_strumright');

	// UI KEYS

	/**
	 * User Interface Key press `UP`
	 */
	public var UI_UP_P(get, never):Bool;

	function get_UI_UP_P()
		return _justPress('_uiup');

	/**
	 * User Interface Key press `DOWN`
	 */
	public var UI_DOWN_P(get, never):Bool;

	function get_UI_DOWN_P()
		return _justPress('_uidown');

	/**
	 * User Interface Key press `LEFT`
	 */
	public var UI_LEFT_P(get, never):Bool;

	function get_UI_LEFT_P()
		return _justPress('_uileft');

	/**
	 * User Interface Key press `RIGHT`
	 */
	public var UI_RIGHT_P(get, never):Bool;

	function get_UI_RIGHT_P()
		return _justPress('_uiright');

	/**
	 * User Interface Key pressed `UP`
	 */
	public var UI_UP(get, never):Bool;

	function get_UI_UP()
		return _pressed('_uiup');

	/**
	 * User Interface Key pressed `DOWN`
	 */
	public var UI_DOWN(get, never):Bool;

	function get_UI_DOWN()
		return _pressed('_uidown');

	/**
	 * User Interface Key pressed `LEFT`
	 */
	public var UI_LEFT(get, never):Bool;

	function get_UI_LEFT()
		return _pressed('_uileft');

	/**
	 * User Interface Key pressed `RIGHT`
	 */
	public var UI_RIGHT(get, never):Bool;

	function get_UI_RIGHT()
		return _pressed('_uiright');

	/**
	 * User Interface Key released `UP`
	 */
	public var UI_UP_R(get, never):Bool;

	function get_UI_UP_R()
		return _justReleased('_uiup');

	/**
	 * User Interface Key released `DOWN`
	 */
	public var UI_DOWN_R(get, never):Bool;

	function get_UI_DOWN_R()
		return _justReleased('_uidown');

	/**
	 * User Interface Key released `LEFT`
	 */
	public var UI_LEFT_R(get, never):Bool;

	function get_UI_LEFT_R()
		return _justReleased('_uileft');

	/**
	 * User Interface Key released `RIGHT`
	 */
	public var UI_RIGHT_R(get, never):Bool;

	function get_UI_RIGHT_R()
		return _justReleased('_uiright');

	// UI STUFF KEYS

	/**
	 * User Interface Key press `ACCEPT`
	 */
	public var ACCEPT(get, never):Bool;

	function get_ACCEPT()
		return _justPress('_uiaccept');

	/**
	 * User Interface Key press `BACK`
	 */
	public var BACK(get, never):Bool;

	function get_BACK()
		return _justPress('_uiback');

	/**
	 * Gameplay Key press `PAUSE`
	 */
	public var PAUSE(get, never):Bool;

	function get_PAUSE()
		return _justPress('_gamepause');

	/**
	 * Gameplay Key press `RESET`
	 */
	public var RESET(get, never):Bool;

	function get_RESET()
		return _justPress('_gamereset');

	/**
	 * Cutscene Key press `ACCEPT`
	 */
	public var CUTSCENE_ACCEPT(get, never):Bool;

	function get_CUTSCENE_ACCEPT()
		return _justPress('_csaccept');

	/**
	 * Cutscene Key press `INGORE`
	 */
	public var CUTSCENE_IGNORE(get, never):Bool;

	function get_CUTSCENE_IGNORE()
		return _justPress('_csignore');

	// Functions

	/**
	 * All Keyboard Binds
	 */
	public var binds_key:Null<Map<String, Array<flixel.input.keyboard.FlxKey>>> = null;

	/**
	 * All Gamepad Binds
	 */
	public var binds_joy:Null<Map<String, Array<flixel.input.gamepad.FlxGamepadInputID>>> = null;

	/**
	 * Is joystick? or not?
	 */
	public var isJoy(default, null):Bool = false;

	private function _justPress(t:String):Bool
	{
		if (!binds_key.exists(t))
			return false;

		var r:Bool = (TempoInput.keysJustPressed(binds_key[t]) == true);
		if (r == true)
			isJoy = false;

		return r || (_joy_justPress(binds_joy[t]) == true);
	}

	private function _pressed(t:String):Bool
	{
		if (!binds_key.exists(t))
			return false;

		var r:Bool = (TempoInput.keysPressed(binds_key[t]) == true);
		if (r == true)
			isJoy = false;

		return r || (_joy_pressed(binds_joy[t]) == true);
	}

	private function _justReleased(t:String):Bool
	{
		if (!binds_key.exists(t))
			return false;

		var r:Bool = (TempoInput.keysJustReleased(binds_key[t]) == true);
		if (r == true)
			isJoy = false;

		return r || (_joy_justReleased(binds_joy[t]) == true);
	}

	private function _joy_pressed(k:Array<flixel.input.gamepad.FlxGamepadInputID>):Bool
	{
		if (k != null)
		{
			for (t in k)
			{
				if (TempoInput.joysticksPressed(t) == true)
				{
					isJoy = true;
					return true;
				}
			}
		}
		return false;
	}

	private function _joy_justPress(k:Array<flixel.input.gamepad.FlxGamepadInputID>):Bool
	{
		if (k != null)
		{
			for (t in k)
			{
				if (TempoInput.joysticksJustPressed(t) == true)
				{
					isJoy = true;
					return true;
				}
			}
		}
		return false;
	}

	private function _joy_justReleased(k:Array<flixel.input.gamepad.FlxGamepadInputID>):Bool
	{
		if (k != null)
		{
			for (t in k)
			{
				if (TempoInput.joysticksJustReleased(t) == true)
				{
					isJoy = true;
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * Use these for more call's of functions
	 */
	public static var instance(get, never):Inputter;

	static var _instance:Null<Inputter> = null;

	/**
	 * For `instance`
	 */
	public function new():Void
	{
		binds_key = Save.binds_key;
		binds_joy = Save.binds_joy;
	}

	static function get_instance():Inputter
	{
		if (Inputter._instance == null)
			_instance = new Inputter();
		if (Inputter._instance == null)
			throw "Could not initialize singleton Inputter";
		return Inputter._instance;
	}
}
