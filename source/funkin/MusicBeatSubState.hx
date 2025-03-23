package funkin;

import engine.backend.Conductor;
import funkin.ui.PlayState;

class MusicBeatSubState extends TempoSubState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;
	private var curStepsDo:Int = 0;

	override function update(elapsed:Float)
	{
		final oldStep = curStep;

		updateCurStep();
		updateCurBeat();

		if (oldStep != curStep)
		{
			if (curStep > 0)
				stepHit();

			if (curStep % 4 == 0)
				beatHit();

			if (Type.getClass(FlxG.state.subState) == PlayState && PlayState.song.chart != null && PlayState.song.meta != null)
			{
				if (oldStep < curStep)
					updateCurSection();
				else
					rollbackCurSection();
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

		curStep = Math.floor(parent.get('stepTime') + (Conductor.instance.songPos - parent.get('songTime')) / Conductor.instance.stepCrochet);
	}

	private function updateCurBeat()
		curBeat = Math.floor(curStep / 4);

	private function updateCurSection()
	{
		if (curStepsDo < 1)
			curStepsDo = roundStep(getBeatsFromSection());
		while (curStep >= curStepsDo)
		{
			curSection++;

			curStepsDo += roundStep(getBeatsFromSection());
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

		if (PlayState.song.chart != null && PlayState.song.meta != null)
		{
			for (i in 0...PlayState.song.chart.sections.get(PlayState.instance.curDifficulty).length)
			{
				if (PlayState.song.chart.sections.get(PlayState.instance.curDifficulty)[i] != null)
				{
					curStepsDo += roundStep(getBeatsFromSection());
					if (curStepsDo > curStep)
						break;

					curSection++;
				}
			}
		}

		if (curSection > last)
			sectionHit();
	}

	private function getBeatsFromSection():Float
	{
		var valve:Null<Float> = 4;

		if (PlayState.song.chart != null && PlayState.song.meta != null)
		{
			if (PlayState.song.chart.sections.get(PlayState.instance.curDifficulty)[curSection] != null)
				valve = PlayState.song.chart.sections.get(PlayState.instance.curDifficulty)[curSection].beats;
		}

		return valve == null ? 4 : valve;
	}

	public function sectionHit():Void
	{
		// override function
	}

	public function stepHit():Void {}

	public function beatHit():Void
	{
		// override function
	}

	function roundStep(value:Float):Int
		return Math.round(value * 4);
}
