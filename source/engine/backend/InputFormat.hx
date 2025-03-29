package engine.backend;

class InputFormat
{
	#if FEATURE_GAMEPAD_ALLOWED
	@:to
	public static function getJoyKeyName(key:FlxGamepadInputID):String
	{
		var str:String = "N\\A";

		return str;
	}
	#end

	@:to
	public static function getKeyName(key:FlxKey, ?supportArrowsFont:Bool = false):String
	{
		var str:String = "N\\A";

		switch (key)
		{
			case BACKSPACE:
				str = "BckSpc";
			case CONTROL:
				str = "Ctrl";
			case ALT:
				str = "Alt";
			case CAPSLOCK:
				str = "Caps";
			case PAGEUP:
				str = "PgUp";
			case PAGEDOWN:
				str = "PgDown";
			case ZERO:
				str = "0";
			case ONE:
				str = "1";
			case TWO:
				str = "2";
			case THREE:
				str = "3";
			case FOUR:
				str = "4";
			case FIVE:
				str = "5";
			case SIX:
				str = "6";
			case SEVEN:
				str = "7";
			case EIGHT:
				str = "8";
			case NINE:
				str = "9";
			case NUMPADZERO:
				str = "#0";
			case NUMPADONE:
				str = "#1";
			case NUMPADTWO:
				str = "#2";
			case NUMPADTHREE:
				str = "#3";
			case NUMPADFOUR:
				str = "#4";
			case NUMPADFIVE:
				str = "#5";
			case NUMPADSIX:
				str = "#6";
			case NUMPADSEVEN:
				str = "#7";
			case NUMPADEIGHT:
				str = "#8";
			case NUMPADNINE:
				str = "#9";
			case NUMPADMULTIPLY:
				str = "#*";
			case NUMPADPLUS:
				str = "#+";
			case NUMPADMINUS:
				str = "#-";
			case NUMPADPERIOD:
				str = "#.";
			case SEMICOLON:
				str = ";";
			case COMMA:
				str = ",";
			case PERIOD:
				str = ".";
			case GRAVEACCENT:
				str = "`";
			case LBRACKET:
				str = "[";
			case RBRACKET:
				str = "]";
			case QUOTE:
				str = "'";
			case PRINTSCREEN:
				str = "PrtScrn";
			case SCROLL_LOCK:
				str = "ScrLk";
			case NONE:
				str = '---';
			case UP:
				str = (supportArrowsFont ? '↑' : "Up");
			case DOWN:
				str = (supportArrowsFont ? '↓' : "Down");
			case LEFT:
				str = (supportArrowsFont ? '←' : "Left");
			case RIGHT:
				str = (supportArrowsFont ? '→' : "Right");
			default:
				if (key.toString().toLowerCase() != 'null')
				{
					var val:Array<String> = key.toString().split('_');
					for (i in 0...val.length)
						val[i] = val[i].toTitleCase();

					str = val.join(' ');
				}
		}
		return str;
	}
}
