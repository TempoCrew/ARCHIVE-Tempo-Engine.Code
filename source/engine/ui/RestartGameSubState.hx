package engine.ui;

import tempo.TempoInput;
import flixel.FlxSubState;

class RestartGameSubState extends FlxSubState
{
	var text:String;
	var onYes:Void->Void;

	public function new(text:String, onYes:Void->Void):Void
	{
		super();

		this.text = text;
		this.onYes = onYes;
	}

	override function create():Void
	{
		var text:FlxText = new FlxText(0, 0, FlxG.width, this.text + '\n"YES" - CTRL / "NO" - ALT', 32);
		text.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.screenCenter();
		add(text);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (TempoInput.keyJustPressed.CONTROL)
		{
			if (onYes != null)
				onYes();

			FlxG.state.persistentUpdate = FlxG.state.persistentDraw = true;
			close();
		}

		if (TempoInput.keyJustPressed.ALT)
		{
			FlxG.state.persistentUpdate = FlxG.state.persistentDraw = true;

			close();
		}

		super.update(elapsed);
	}
}
