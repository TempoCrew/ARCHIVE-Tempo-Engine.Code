package engine.ui.debug;

class CharacterEditorState extends EditorState
{
	public function new():Void
	{
		super(CHARACTER);
	}

	override function create():Void
	{
		super.create();

		var bg:TempoSprite = new TempoSprite(0, 0, GRAPHIC).makeImage({path: Paths.image('menuDesat', null, false)});
		bg.scrollFactor.set();
		bg.setGraphicSize(bg.width * 1.175);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		updateWindow("--C Character Editor", "icon-5", [
			"Character Editor",
			"test",
			"character-editor",
			"Character Editor v0.1.0",
			"bf",
			"BF"
		]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
