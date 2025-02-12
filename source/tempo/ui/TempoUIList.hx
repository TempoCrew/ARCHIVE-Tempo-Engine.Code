package tempo.ui;

class TempoUIList extends FlxGroup
{
	public static final TEXT_BIND_POS:Float = 7.5;

	public var bg:TempoSprite;
	public var listBG:Array<TempoSprite> = [];
	public var listBind:Array<FlxText> = [];
	public var listText:Array<FlxText> = [];

	public var maxWidth:Float = 0;
	public var maxHeight:Float = 0;

	public var addHeight:Float = 0;

	public var types:Array<TempoUIListType> = [];

	public function new(x:Float, y:Float, data:Array<TempoUIListData>):Void
	{
		super();

		bg = new TempoSprite(x, y);
		add(bg);

		for (i in 0...data.length)
		{
			if (data[i] != null)
			{
				var text:FlxText = new FlxText(x + 5, 0, 500, (data[i].text == null ? "Button" : data[i].text), 16);
				text.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE);
				text.scrollFactor.set();
				text.fieldWidth = text.textField.textWidth + 6.5;

				this.types.push(data[i].type);

				var bind:FlxText = null;

				if (data[i].bind != null)
				{
					bind = new FlxText(x + 5, 0, 500, data[i].bind, 16);
					bind.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT, OUTLINE_FAST);
					bind.scrollFactor.set();
					bind.fieldWidth = bind.textField.textWidth + 6.5;
				}
				else if (data[i].type == HOVER)
				{
					bind = new FlxText(x + 5, 0, 500, ">", 16);
					bind.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT, OUTLINE_FAST);
					bind.scrollFactor.set();
					bind.fieldWidth = bind.textField.textWidth + 6.5;
				}

				var bg:TempoSprite = new TempoSprite(x + 2.5, y + 2.5);
				bg.makeGraphic(1, Math.floor(text.textField.textHeight + 5), FlxColor.TRANSPARENT);
				bg.y += (bg.height * (i - addHeight)) + addHeight;
				bg.scrollFactor.set();

				text.y = bg.y + 2.5;
				if (bind != null)
				{
					bind.x = (text.x + text.textField.textWidth) + TEXT_BIND_POS;
					bind.y = bg.y + 2.5;
				}

				listBG.push(bg);
				listText.push(text);
				if (bind != null)
					listBind.push(bind);
			}
			else
			{
				addHeight += 1;
			}
		}

		for (bg in listBG)
		{
			add(bg);
		}

		for (text in listText)
		{
			add(text);

			trace(text.textField.textWidth);

			if (text.textField.textWidth >= maxWidth)
				maxWidth = text.textField.textWidth;

			if (listBind.length != 0)
			{
				for (bind in listBind)
				{
					if ((bind.textField.textWidth + text.textField.textWidth + TEXT_BIND_POS) >= maxWidth)
						maxWidth = (bind.textField.textWidth + text.textField.textWidth + TEXT_BIND_POS);

					bind.setPosition(text.x + (maxWidth - bind.fieldWidth), bind.y);
					bind.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT, OUTLINE_FAST);
					add(bind);
				}
			}
		}

		for (bg in listBG)
		{
			bg.makeRoundRect({
				width: maxWidth + 5,
				height: bg.height,
				color: Constants.COLOR_EDITOR_LIST_BOX,
				roundRect: {elWidth: 10, elHeight: 10}
			});

			maxHeight += bg.height;
		}

		bg.makeRoundRect({
			width: maxWidth + 10,
			height: maxHeight + 2.5 + (addHeight != 0 ? addHeight + 2.5 : 0),
			color: Constants.COLOR_EDITOR_LIST_BUTTON,
			roundRect: {elWidth: 10, elHeight: 10}
		});

		trace('maxWidth: $maxWidth');
	}

	@:access(flixel.FlxCamera)
	override function draw():Void
	{
		if (_cameras != null)
		{
			if (bg != null)
				bg.cameras = _cameras;

			for (abg in listBG)
				abg.cameras = _cameras;

			for (text in listText)
				text.cameras = _cameras;

			if (listBind.length != 0)
				for (bind in listBind)
					bind.cameras = _cameras;
		}

		super.draw();
	}

	override function update(elapsed:Float):Void
	{
		if (visible)
		{
			for (i in 0...listBG.length)
			{
				var overlaped:Bool = TempoInput.cursorOverlaps(listBG[i], this.cameras[this.cameras.length - 1]);

				if (overlaped)
				{
					listBG[i].alpha = .6;

					if (types[i] == HOVER)
					{
						// nothing, for now
					}
					else if (types[i] == BUTTON)
					{
						if (TempoInput.cursorJustReleased)
						{
							listBG[i].alpha = .25;
							trace('clicked!');
							visible = false;
						}
						else if (TempoInput.cursorPressed)
							listBG[i].alpha = 1;
					}
				}
				else
					listBG[i].alpha = .25;
			}
		}

		super.update(elapsed);
	}
}

typedef TempoUIListData =
{
	tag:String,
	type:TempoUIListType,
	?text:String,
	?bind:String,
	?radio:Array<String>,
	?hoverData:Array<TempoUIListData>
}

enum abstract TempoUIListType(String) from String to String
{
	var BUTTON:String = "_button";
	var HOVER:String = "_hover";
	var DROPDOWN:String = "_dropdown";
	var STEPPER:String = "_stepper";
	var SLIDER:String = "_slider";
	var RADIO:String = "_radio";
	var CHECKBOX:String = "_checkbox";
}
