package engine.types;

typedef VolUpdateData<T:FlxSound> =
{
	var sound:T;
	var toVolume:Float;
	var addVolume:Float;
	var elapsed:Float;
}
