package tempo.types;

import openfl.display.TriangleCulling;
import openfl.Vector;

typedef TempoSpriteGFX =
{
	?roundRect:
		{
			?elWidth:Float,
			?elHeight:Float,
			?elBottomLeft:Float,
			?elBottomRight:Float,
			?elTopLeft:Float,
			?elTopRight:Float
		},
	?circle:{radius:Float},
	?ellipse:{width:Float, height:Float},
	?quad:
		{
			rects:Vector<Float>,
			?indices:Vector<Int>,
			?transforms:Vector<Float>
		},
	?triangle:
		{
			verices:Vector<Float>,
			?indices:Vector<Int>,
			?uvtData:Vector<Float>,
			?culling:TriangleCulling
		}
}
