package engine.ui.debug;

class AudioEditorState extends EditorState
{
	public function new():Void
	{
		super(AUDIO);
	}

	override function create():Void
	{
		super.create();

		updateWindow("--C Audio Editor", "icon-6", ["Audio Editor", "test", "audio-editor", "Audio Editor v0.1.0"]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
