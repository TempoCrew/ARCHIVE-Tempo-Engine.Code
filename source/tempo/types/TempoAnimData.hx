package tempo.types;

typedef TempoAnimData =
{
	name:String,
	prefix:String,
	?framerate:Int,
	?looped:Bool,
	?offsets:TempoOffset,
	?indices:Array<Int>,
	?postfix:String
}
