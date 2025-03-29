package tempo.ui;

class TempoUICheckbox extends TempoSpriteGroup implements ITempoUI
{
	public var bg:TempoSprite;
	public var box:TSG;
	public var text:FlxText;

	public var value(default, set):Bool = false;
	public var onCallback:Bool->Void = null;

	public var name:String;
	public var broadcastToUI:Bool = true;
	public var overlaped:Bool;
	public var ignoreErrors:Bool;

	public function new(X:Float = 0, Y:Float = 0, ?Label:String = "Check", ?defaultValue:Bool = false, ?size:FlxPoint, ?onCallback:Bool->Void):Void
	{
		super(X, Y);

		if (size == null)
			size = FlxPoint.get(16, 16);

		bg = new TempoSprite(0, 0, GRAPHIC);

		box = new TSG(5, 5, 'checkbox');
		box.graphicLoad('checkbox', true, 64, 64);
		box.animation.add("h", [0, 1], 0, false);
		box.animation.play('h');
		box.setGraphicSize(size.x, size.y);
		box.updateHitbox();
		box.scrollFactor.set();

		text = new FlxText((box.x + box.width) + 2.5, box.y, 0, Label, Math.floor(size.y - 4));
		text.setFormat(Paths.font('vcr.ttf'), Math.floor(size.y - 4), FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.updateHitbox();

		bg.makeRoundRect({
			width: (box.width + text.textField.textWidth) + 7.5,
			height: size.y + 5,
			color: FlxColor.BLACK,
			elWidth: 10,
			elHeight: 10
		});
		bg.scrollFactor.set();
		bg.alpha = .001;

		add(bg);
		add(box);
		add(cast(text, TempoSprite));

		this.value = defaultValue;
		this.onCallback = onCallback;
	}

	var mouseCount:Int = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (mouseCount < 1 && ())
		{
			mouseCount = 2;

			if (broadcastToUI)
				TempoUI.event(TempoUIEvents.CHECKBOX_HOVER, this);

			bg.alpha = .6;
		}
		else if (mouseCount == 2 && (!TempoInput.cursorOverlaps(bg) || !TempoInput.cursorOverlaps(text)))
		{
			mouseCount = 0;

			bg.alpha = .001;
		}

		if (mouseCount == 2)
		{
			if (TempoInput.cursorJustReleased)
			{
				value = !value;

				if (onCallback != null)
					onCallback(value);
				if (broadcastToUI)
					TempoUI.event(TempoUIEvents.CHECKBOX_CHANGE, this);
			}
			else if (TempoInput.cursorPressed)
			{
				bg.alpha = .85;
			}
		}
	}

	function set_value(v:Bool):Bool
	{
		value = v;
		box.animation.curAnim.curFrame = (value == true ? 1 : 0);

		return value;
	}
}
