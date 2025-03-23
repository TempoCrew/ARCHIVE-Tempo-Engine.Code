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
