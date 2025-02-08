package tempo;

import flixel.input.touch.FlxTouchManager;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKeyList;
#if FEATURE_GAMEPAD_ALLOWED
import flixel.input.gamepad.FlxGamepadAnalogStick;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.input.gamepad.FlxGamepad;
#end
import flixel.input.android.FlxAndroidKey;
import flixel.input.android.FlxAndroidKeyList;
import flixel.input.android.FlxAndroidKeys;

@:access(flixel.input.keyboard.FlxKeyboard)
class TempoInput
{
	/**
	 * Current using keyboard
	 */
	public static var keyboard(get, never):FlxKeyboard;

	static function get_keyboard():FlxKeyboard
		return FlxG.keys;

	/**
	 * Key from Keyboard just pressed
	 */
	public static var keyJustPressed(get, never):FlxKeyList;

	static function get_keyJustPressed():FlxKeyList
		return keyboard.justPressed;

	/**
	 * Key from Keyboard just released
	 */
	public static var keyJustReleased(get, never):FlxKeyList;

	static function get_keyJustReleased():FlxKeyList
		return keyboard.justReleased;

	/**
	 * Key from Keyboard pressed
	 */
	public static var keyPressed(get, never):FlxKeyList;

	static function get_keyPressed():FlxKeyList
		return keyboard.pressed;

	/**
	 * Key from Keyboard released
	 */
	public static var keyReleased(get, never):FlxKeyList;

	static function get_keyReleased():FlxKeyList
		return keyboard.released;

	/**
	 * Returning current keys checked or no?
	 * @param keys Keys from Keyboard, for checking - just pressed or no?
	 */
	public static function keysJustPressed(keys:Array<FlxKey>):Bool
		return keyboard.anyJustPressed(keys);

	/**
	 * Returning current keys checked or no?
	 * @param keys Keys from Keyboard, for checking - just released or no?
	 */
	public static function keysJustReleased(keys:Array<FlxKey>):Bool
		return keyboard.anyJustReleased(keys);

	/**
	 * Returning current keys checked or no?
	 * @param keys Keys from Keyboard, for checking - pressed or no?
	 */
	public static function keysPressed(keys:Array<FlxKey>):Bool
		return keyboard.anyPressed(keys);

	/**
	 * Current using touch devices.
	 */
	public static var touches(get, never):FlxTouchManager;

	static function get_touches():FlxTouchManager
		return FlxG.touches;

	/**
	 * Return touch device just pressed value.
	 */
	public static var touchesJustPressed(get, never):Bool;

	static function get_touchesJustPressed():Bool
	{
		for (touch in touches.list)
			return touch.justPressed;

		return false;
	}

	/**
	 * Get a touched just pressed positions
	 * @return Just Pressed Positions.
	 */
	public static function touchesJustPressedPos():FlxPoint
	{
		for (touch in touches.list)
			return touch.justPressedPosition;

		return FlxPoint.get();
	}

	/**
	 * Get a touched time in ticks
	 * @return Time in sticks touch just pressed.
	 */
	public static function touchesJustPressedTimeInTicks():Int
	{
		for (touch in touches.list)
			return touch.justPressedTimeInTicks;

		return 0;
	}

	/**
	 * Return touch device pressed value.
	 */
	public static var touchesPressed(get, never):Bool;

	static function get_touchesPressed():Bool
	{
		for (touch in touches.list)
			return touch.pressed;

		return false;
	}

	/**
	 * Return touch device released value.
	 */
	public static var touchesReleased(get, never):Bool;

	static function get_touchesReleased():Bool
	{
		for (touch in touches.list)
			return touch.released;

		return false;
	}

	/**
	 * Return touch device just released value.
	 */
	public static var touchesJustReleased(get, never):Bool;

	static function get_touchesJustReleased():Bool
	{
		for (touch in touches.list)
			return touch.justReleased;

		return false;
	}

	#if (android && native)
	/**
	 * Current android device
	 */
	public static var android(get, never):FlxAndroidKeys;

	static function get_android():FlxAndroidKeys
		return FlxG.android;
	#end

	#if FEATURE_GAMEPAD_ALLOWED
	/**
	 * Current using gamepads (joysticks, i just often call it that)
	 */
	public static var joysticks(get, never):FlxGamepadManager;

	static function get_joysticks():FlxGamepadManager
		return FlxG.gamepads;

	/**
	 * Something of gamepads are pressed something or not? (ex: buttons, ball and etc.)
	 */
	public static var joysticksAnyPressed(get, never):Bool;

	static function get_joysticksAnyPressed():Bool
		return joysticks.anyInput();

	/**
	 * Get a gamepads selected input state
	 * @param state Input State (`PRESSED`, `JUST_RELEASED`, `RELEASED`, `JUST_PRESSED`)
	 */
	public static function joysticksButton(state:FlxInputState = PRESSED):Bool
		return joysticks.anyButton(state);

	/**
	 * Returning a `false` / `true` value, id current `id` pressed.
	 * @param id Gamepad Button ID
	 */
	public static function joysticksPressed(id:FlxGamepadInputID):Bool
		return joysticks.anyPressed(id);

	/**
	 * Returning a `false` / `true` value, if current `id` just pressed.
	 * @param id Gamepad Button ID
	 */
	public static function joysticksJustPressed(id:FlxGamepadInputID):Bool
		return joysticks.anyJustPressed(id);

	/**
	 * Returning a `false` / `true` value, if current `id` just released.
	 * @param id Gamepad Button ID
	 */
	public static function joysticksJustReleased(id:FlxGamepadInputID):Bool
		return joysticks.anyJustReleased(id);

	/**
	 * Returning a `false` / `true` value, if current `id` moved.
	 * @param id Gamepad analog sticks X.
	 */
	public static function joysticksMovedXAxis(id:FlxGamepadAnalogStick):Float
		return joysticks.anyMovedXAxis(id);

	/**
	 * Return a `false` / `true` value, id current `id` moved.
	 * @param id Gamepad analog sticks Y
	 */
	public static function joysticksMovedYAxis(id:FlxGamepadAnalogStick):Float
		return joysticks.anyMovedXAxis(id);
	#end

	/**
	 * Current using mouse (cursor).
	 */
	public static var cursor(get, never):flixel.input.mouse.FlxMouse;

	static function get_cursor():flixel.input.mouse.FlxMouse
		return FlxG.mouse;

	/**
	 * Mouse just pressed Left Button
	 */
	public static var cursorJustPressed(get, never):Bool;

	static function get_cursorJustPressed():Bool
		return cursor.justPressed;

	/**
	 * Mouse just pressed Middle Button
	 */
	public static var cursorJustPressed_M(get, never):Bool;

	static function get_cursorJustPressed_M():Bool
		return cursor.justPressedMiddle;

	/**
	 * Mouse just pressed Right Button
	 */
	public static var cursorJustPressed_R(get, never):Bool;

	static function get_cursorJustPressed_R():Bool
		return cursor.justPressedRight;

	/**
	 * Mouse just released Left Button
	 */
	public static var cursorJustReleased(get, never):Bool;

	static function get_cursorJustReleased():Bool
		return cursor.justReleased;

	/**
	 * Mouse just released Middle Button
	 */
	public static var cursorJustReleased_M(get, never):Bool;

	static function get_cursorJustReleased_M():Bool
		return cursor.justReleasedMiddle;

	/**
	 * Mouse just released Right Button
	 */
	public static var cursorJustReleased_R(get, never):Bool;

	static function get_cursorJustReleased_R():Bool
		return cursor.justReleasedRight;

	/**
	 * Mouse released Left Button
	 */
	public static var cursorReleased(get, never):Bool;

	static function get_cursorReleased():Bool
		return cursor.released;

	/**
	 * Mouse released Middle Button
	 */
	public static var cursorReleased_M(get, never):Bool;

	static function get_cursorReleased_M():Bool
		return cursor.releasedMiddle;

	/**
	 * Mouse released Right Button
	 */
	public static var cursorReleased_R(get, never):Bool;

	static function get_cursorReleased_R():Bool
		return cursor.releasedRight;

	/**
	 * Mouse pressed Left Button
	 */
	public static var cursorPressed(get, never):Bool;

	static function get_cursorPressed():Bool
		return cursor.pressed;

	/**
	 * Mouse pressed Middle Button
	 */
	public static var cursorPressed_M(get, never):Bool;

	static function get_cursorPressed_M():Bool
		return cursor.pressedMiddle;

	/**
	 * Mouse pressed Right Button
	 */
	public static var cursorPressed_R(get, never):Bool;

	static function get_cursorPressed_R():Bool
		return cursor.pressedRight;

	/**
	 * Mouse moving or not
	 */
	public static var cursorMoved(get, never):Bool;

	static function get_cursorMoved():Bool
		return cursor.justMoved;

	/**
	 * Mouse overlaps something function
	 * @param BasicObject Current object, where cursor want overlap
	 * @param Camera If this object with different camera, recommended here paste current camera
	 * @return `this` object overlaped or no?
	 */
	public static function cursorOverlaps<T:FlxCamera>(BasicObject:flixel.FlxBasic, ?Camera:T):Bool
		return cursor.overlaps(BasicObject, Camera);

	/**
	 * Mouse wheel value (if `up` - positive, `down` - negative)
	 * @return Wheel value in Float (for `Int`, use `Std.int()` or `Math.floor()`)
	 */
	public static var cursorWheel(get, never):Float;

	static function get_cursorWheel():Float
		return cursor.wheel;

	/**
	 * Mouse wheel is moved or not
	 */
	public static var cursorWheelMoved(get, never):Bool;

	static function get_cursorWheelMoved():Bool
		return (TempoInput.cursorWheel != 0.0);
}
