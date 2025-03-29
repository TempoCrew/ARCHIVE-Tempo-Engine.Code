package engine.ui.debug;

class AnimationEditorState extends EditorState
{
	public function new():Void
	{
		super(ANIMATE);
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

		updateWindow("--C Animation Editor", "icon-2", [
			"Animation Editor",
			"test",
			"animation-editor",
			"Animation Editor v0.1.0",
			"bf",
			"BF"
		]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
