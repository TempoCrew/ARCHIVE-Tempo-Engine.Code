package funkin;

import engine.backend.Conductor;
import flixel.util.FlxSignal.FlxTypedSignal;

class MusicBeatState extends TempoState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var curStepsDo:Int = 0;

	private var curDecBeat:Float = 0;
	private var curDecStep:Float = 0;
	private var curDecSection:Float = 0;

	override function update(elapsed:Float)
	{
		final oldStep = curStep;

		updateCurStep();
		updateCurBeat();

		if (oldStep != curStep)
		{
			if (curStep > 0)
			{
				stepHit();

				if (curStep % 4 == 0)
					beatHit();
			}
		}

		super.update(elapsed);
	}

	@:access(engine.backend.Conductor)
	private function updateCurStep()
	{
		var parent:Map<String, Float> = ["stepTime" => 0, "songTime" => 0, "bpm" => 0];

		for (i in 0...Conductor.instance.bpmChangeMap.length)
		{
			if (Conductor.instance.songPos >= Conductor.instance.bpmChangeMap[i].get('songTime'))
				parent = Conductor.instance.bpmChangeMap[i];
		}

		curDecStep = parent.get('stepTime') + ((Conductor.instance.songPos - parent.get('songTime')) / Conductor.instance.stepCrochet);
		curStep = Math.floor(parent.get('stepTime') + (Conductor.instance.songPos - parent.get('songTime')) / Conductor.instance.stepCrochet);
	}

	private function updateCurBeat()
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep / 4;
	}

	private function updateCurSection()
	{
		if (curStepsDo < 1)
			curStepsDo = Math.round(getBeatsFromSection() * 4);

		while (curStep >= curStepsDo)
		{
			curSection++;

			var leBeats:Float = getBeatsFromSection();
			curStepsDo += Math.round(leBeats * 4);
			sectionHit();
		}
	}

	private function rollbackCurSection()
	{
		if (curStep < 0)
			return;

		var last:Int = curSection;
		curSection = 0;
		curStepsDo = 0;

		if (curSection > last)
			sectionHit();
	}

	private function getBeatsFromSection():Float
	{
		var valve:Null<Float> = 4;
		return valve == null ? 4 : valve;
	}

	public function sectionHit():Void
	{
		// override function
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// override function
	}
}
