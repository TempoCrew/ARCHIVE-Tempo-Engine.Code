package tempo.types;

typedef TempoSpriteTriangle =
{
	width:Float,
	height:Float,
	color:FlxColor,
	verices:openfl.Vector<Float>,
	?indices:openfl.Vector<Int>,
	?uvtData:openfl.Vector<Float>,
	?culling:openfl.display.TriangleCulling
}
