package tempo.ui;

import engine.input.Cursor;
import engine.backend.util.SpriteUtil;
import engine.backend.util.MemoryUtil;
import tempo.ui.interfaces.ITempoUI;

/**
 * `Tempo-UI` is reimagined/recoded/remaked (re-re-re-re-re-re-re lol) `Flixel-UI`.
 * but `Flixel-UI` is so old and not functional in some cases, so i created my own `Tempo-UI`.
 */
class TempoUI
{
	public static var customCursorAllowed:Bool = false;

	/**
	 * Add a new event
	 * @param tag event name
	 * @param sender thing where event will do
	 */
	public static function event(tag:String, sender:ITempoUI):Void
	{
		var curState:IEventGetter = getUIState();

		if (curState != null)
			curState.getEvent(tag, sender);
		else
			trace('$tag not called! Current state is NULL!');
	}

	/**
	 * Focused a `thing`
	 * @param value this `thing` focused or not (false or true)
	 * @param thing ok
	 */
	public static function focus(value:Bool, thing:ITempoUI):Void
	{
		var curState:ITempoUIState = getUIState();

		if (curState != null)
			curState.getFocus(value, thing);
		else
			trace('Focus not called! Current state is NULL!');
	}

	public static function cursor(?id:CursorMode = Default, ?visible:Bool = true):Void
	{
		Cursor.cursorMode = id;

		if (visible)
			Cursor.show();
		else
			Cursor.hide();
	}

	public static function getUIState():ITempoUIState
	{
		var state:flixel.FlxState = FlxG.state;
		if (state != null)
		{
			while (state.subState != null)
			{
				state = state.subState;
			}
		}
		if ((state is ITempoUIState))
		{
			return cast state;
		}
		return null;
	}
}
