package funkin.ui.menus;

import haxe.Serializer;
import flixel.FlxState;
import engine.ui.debug.*;

class TitleState extends MusicBeatState
{
	override public function create()
	{
		var text:FlxText = new FlxText(2.5, 5, FlxG.width, "", 32);
		text.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.text = "Editors:\nF1 - Chart Editor\nF2 - Animation Editor\nF3 - Stage Editor\nF4 - Level Editor\n\nMenus:\nTAB - GameJolt\nF5 - Freeplay";
		add(text);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (TempoInput.keyJustPressed.F1)
			TempoState.switchState(new ChartEditorState());
		else if (TempoInput.keyJustPressed.F2)
			TempoState.switchState(new AnimationEditorState());
		else if (TempoInput.keyJustPressed.F3)
			TempoState.switchState(new StageEditorState());
		else if (TempoInput.keyJustPressed.F4)
			TempoState.switchState(new LevelEditorState());
		else if (TempoInput.keyJustPressed.F6)
			TempoState.switchState(new TrophiesState());
		else if (TempoInput.keyJustPressed.TAB)
			TempoState.switchState(new GameJoltState());
		else if (TempoInput.keyJustPressed.F5)
			openSubState(new FreeplaySubState());

		super.update(elapsed);
	}
}
