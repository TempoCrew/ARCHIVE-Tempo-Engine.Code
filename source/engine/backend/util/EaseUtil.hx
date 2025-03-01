package engine.backend.util;

class EaseUtil
{
	public static function easeInOutCirc(x:Float):Float
	{
		if (x <= 0.0)
			return 0.0;
		if (x >= 1.0)
			return 1.0;
		var result:Float = (x < 0.5) ? (1 - Math.sqrt(1 - 4 * x * x)) / 2 : (Math.sqrt(1 - 4 * (1 - x) * (1 - x)) + 1) / 2;
		return (result == Math.NaN) ? 1.0 : result;
	}

	public static function easeInOutBack(x:Float, ?c:Float = 1.70158):Float
	{
		if (x <= 0.0)
			return 0.0;
		if (x >= 1.0)
			return 1.0;
		var result:Float = (x < 0.5) ? (2 * x * x * ((c + 1) * 2 * x - c)) / 2 : (1 - 2 * (1 - x) * (1 - x) * ((c + 1) * 2 * (1 - x) - c)) / 2;
		return (result == Math.NaN) ? 1.0 : result;
	}

	public static function easeInBack(x:Float, ?c:Float = 1.70158):Float
	{
		if (x <= 0.0)
			return 0.0;
		if (x >= 1.0)
			return 1.0;
		return (1 + c) * x * x * x - c * x * x;
	}

	public static function easeOutBack(x:Float, ?c:Float = 1.70158):Float
	{
		if (x <= 0.0)
			return 0.0;
		if (x >= 1.0)
			return 1.0;
		return 1 + (c + 1) * Math.pow(x - 1, 3) + c * Math.pow(x - 1, 2);
	}
}
