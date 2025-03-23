package engine.ui.debug;

class NoteEditorState extends EditorState
{
	public function new():Void
	{
		super(NOTE);
	}

	override function create():Void
	{
		super.create();

		updateWindow("--C Note Editor", "icon-7", ["Note Editor", "test", "note-editor", "Note Editor v0.1.0"]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
