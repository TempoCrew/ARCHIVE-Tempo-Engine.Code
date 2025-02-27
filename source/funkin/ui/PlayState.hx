package funkin.ui;

import funkin.backend.song.MetaFile;
import funkin.backend.song.ChartFile;
import flixel.FlxState;

class PlayState extends MusicBeatSubState
{
	public static var instance:PlayState;

	public static var song:{chart:ChartFile, meta:MetaFile};

	public var curDifficulty:String = "normal";

	override public function create()
	{
		instance = this;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
