package funkin.ui.menus;

import flixel.FlxState;
import engine.ui.debug.*;

class TitleState extends FlxState
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
			FlxG.switchState(new ChartEditorState());
		else if (TempoInput.keyJustPressed.F2)
			FlxG.switchState(new AnimationEditorState());
		else if (TempoInput.keyJustPressed.F3)
			FlxG.switchState(new StageEditorState());
		else if (TempoInput.keyJustPressed.F4)
			FlxG.switchState(new LevelEditorState());
		else if (TempoInput.keyJustPressed.TAB)
			FlxG.switchState(new GameJoltState());
		else if (TempoInput.keyJustPressed.F5)
			FlxG.state.openSubState(new FreeplaySubState());

		super.update(elapsed);
	}
}
