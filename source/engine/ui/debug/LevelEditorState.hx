package engine.ui.debug;

class LevelEditorState extends EditorState
{
	public function new():Void
	{
		super(LEVEL);
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

		updateWindow("--C Level Editor", "icon-4", ["Level Editor", "test", "level-editor", "Level Editor v0.1.0"]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
