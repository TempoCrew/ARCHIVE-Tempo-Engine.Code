package engine.backend.util;

class ConductorUtil
{
	inline public static function bpmToCrochet(bpm:Float):Float
		return (60 / bpm) * 1000;
}
