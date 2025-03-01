package funkin.ui.menus;

import flixel.FlxSubState;

class FreeplaySubState extends MusicBeatSubState
{
	override function create():Void
	{
		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (TempoInput.keyJustPressed.ESCAPE)
			close();
	}
}
