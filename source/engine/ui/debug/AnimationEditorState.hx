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
