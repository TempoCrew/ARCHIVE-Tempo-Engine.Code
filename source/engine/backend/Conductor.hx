package engine.backend;

import funkin.backend.song.MetaFile;
import funkin.backend.song.ChartFile;
import engine.backend.util.ConductorUtil;

class Conductor
{
	public static var instance(get, never):Conductor;
	static var _instance:Null<Conductor> = null;

	public var bpm(default, set):Float = 100;
	public var crochet:Float = 0;
	public var stepCrochet:Float = 0;
	public var songPos:Float = 0;
	public var offset:Float = 0;
	public var safeZoneOffset:Float = 0;
	public var bpmChangeMap:Array<Map<String, Float>> = [];

	public function new():Void {}

	public function getCrochetAtTime(value:Float):Float
	{
		final last:Map<String, Float> = getBPMFromSeconds(value);
		return last.get('stepCrochet') * Constants.STEPS_PER_BEAT;
	}

	public function getBPMFromSeconds(value:Float):Map<String, Float>
	{
		var last:Map<String, Float> = ["stepTime" => 0, "songTime" => 0, "bpm" => bpm, "stepCrochet" => stepCrochet];

		for (i in 0...bpmChangeMap.length)
			if (value >= bpmChangeMap[i].get('songTime'))
				last = bpmChangeMap[i];

		return last;
	}

	public function changeMapBPM(chart:ChartFile, metadata:MetaFile, diff:String):Void
	{
		this.bpmChangeMap = [];

		var currentBPM:Float = metadata.bpm;
		var totalSteps:Int = 0;
		var totalPosition:Float = .0;
		for (i in 0...chart.sections.get(diff).length)
		{
			if (chart.sections.get(diff)[i].changeBPM && chart.sections.get(diff)[i].bpm != currentBPM)
			{
				currentBPM = chart.sections.get(diff)[i].bpm;
				final event:Map<String, Float> = [
					"stepTime" => totalSteps,
					"songTime" => totalPosition,
					"bpm" => currentBPM,
					"stepCrochet" => ConductorUtil.bpmToCrochet(currentBPM) / Constants.STEPS_PER_BEAT
				];
				this.bpmChangeMap.push(event);
			}

			final deltaSteps = this.getSectionBeats(chart, i, diff) * Constants.STEPS_PER_BEAT;
			totalSteps += Math.floor(deltaSteps.round());
			totalPosition += (ConductorUtil.bpmToCrochet(currentBPM) / Constants.STEPS_PER_BEAT) * deltaSteps.round();
		}

		trace("Change BPM Map (" + bpmChangeMap + ")");
	}

	public function getSectionBeats(chart:ChartFile, section:Int, diff:String):Float
	{
		var val:Null<Float> = null;
		if (chart.sections.get(diff)[section] != null)
			val = chart.sections.get(diff)[section].beats;

		return val != null ? val : Constants.STEPS_PER_BEAT;
	}

	function set_bpm(v:Float):Float
	{
		this.bpm = v;
		this.crochet = ConductorUtil.bpmToCrochet(this.bpm);
		this.stepCrochet = this.crochet / Constants.STEPS_PER_BEAT;

		return this.bpm = v;
	}

	static function get_instance():Conductor
	{
		if (Conductor._instance == null)
			_instance = new Conductor();
		if (Conductor._instance == null)
			throw "Could not initialize singleton Conductor";
		return Conductor._instance;
	}
}
