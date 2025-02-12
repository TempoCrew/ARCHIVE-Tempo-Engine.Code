package tempo.ui;

class TempoUIListButton extends FlxGroup
{
	public var bg:TempoSprite;
	public var text:FlxText;
	public var others:Array<TempoUIListButton> = null;

	public function new(x:Float, str:String):Void
	{
		super();

		text = new FlxText(x + 2.5, 2.5 + 7.5, 500, str, 16);
		text.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.TRANSPARENT);
		text.fieldWidth = text.textField.textWidth + 7.5;
		text.scrollFactor.set();

		bg = new TempoSprite(x, 7.5).makeRoundRect({
			width: text.fieldWidth + 2.5,
			height: text.height + 5,
			color: Constants.COLOR_EDITOR_LIST_BUTTON,
			roundRect: {elWidth: 10, elHeight: 10}
		});
		bg.alpha = .001;
		bg.scrollFactor.set();
		add(bg);
		add(text);
	}

	@:access(flixel.FlxCamera)
	override function draw():Void
	{
		if (_cameras != null)
		{
			if (bg != null)
				bg.cameras = _cameras;
			if (text != null)
				text.cameras = _cameras;
		}

		super.draw();
	}

	public var cursorOverlaped:Bool = false;
	public var cursorClicked:Bool = false;

	override function update(elapsed:Float):Void
	{
		final overlaped:Bool = TempoInput.cursorOverlaps(bg, this.cameras[this.cameras.length - 1]);

		if (overlaped && !cursorOverlaped && !cursorClicked)
		{
			cursorOverlaped = true;
			bg.alpha = .6;
		}
		else if (!overlaped && cursorOverlaped && !cursorClicked)
		{
			cursorOverlaped = false;
			bg.alpha = .001;
		}

		if (cursorOverlaped && TempoInput.cursorJustPressed && !cursorClicked)
		{
			cursorClicked = true;
			bg.alpha = 1.0;
		}
		else if (overlaped && cursorClicked && TempoInput.cursorJustPressed)
		{
			cursorClicked = false;
			bg.alpha = .6;
		}
		else if (!overlaped && cursorClicked && TempoInput.cursorJustReleased)
		{
			cursorClicked = false;
			cursorOverlaped = false;
			bg.alpha = .001;
		}

		if (others != null)
		{
			for (other in others)
			{
				if (other == this)
					others.remove(other);

				if (!overlaped && TempoInput.cursorOverlaps(other, other.cameras[other.cameras.length - 1]) && cursorClicked)
				{
					other.bg.alpha = 1.0;
					other.cursorClicked = true;
					other.cursorOverlaped = true;
					bg.alpha = .001;
				}
			}
		}

		super.update(elapsed);
	}
}
