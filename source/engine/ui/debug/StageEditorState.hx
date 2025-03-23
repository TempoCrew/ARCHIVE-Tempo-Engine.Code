package engine.ui.debug;

class StageEditorState extends EditorState
{
	public function new():Void
	{
		super(STAGE);
	}

	override function create():Void
	{
		super.create();

		updateWindow("--C Stage Editor", "icon-3", ["Stage Editor", "test", "stage-editor", "Stage Editor v0.1.0"]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
