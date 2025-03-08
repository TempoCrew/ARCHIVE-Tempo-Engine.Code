package tempo.ui;

import flixel.group.FlxSpriteGroup;

@:access(tempo.ui.TempoUI)
class TempoUIArrow extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "";
	public var broadcastToUI:Bool = true;

	/**
	 * Button background sprite.
	 */
	public var bg:Null<TempoSprite> = null;

	/**
	 * Button name text sprite.
	 */
	public var text:Null<FlxText> = null;

	/**
	 * Button key-bind for call `onOverlap` variable.
	 */
	private var arrowText:Null<FlxText> = null;

	/**
	 * Change this, if button do not working.
	 */
	public var working(default, set):Bool = true;

	function set_working(v:Bool):Bool
	{
		working = v;

		if (!v)
		{
			if (text != null)
				text.color = FlxColor.GRAY;
			if (arrowText != null)
				arrowText.color = FlxColor.GRAY;
		}

		return v;
	}

	/**
	 * Overlap call function.
	 */
	public var onOverlap:Null<TempoUIArrow->Void> = null;

	/**
	 * Non-Overlap call function
	 */
	public var nonOverlap:Null<TempoUIArrow->Void> = null;

	/**
	 * Overlaped and list data called
	 */
	public var listData:Array<List_Type_Data> = null;

	private var _addTimers:Array<FlxTimer> = [];

	public function new(x:Float, y:Float, text:String, ?addWidth:Float = 0, ?addHeight:Float, ?onOverlap:TempoUIArrow->Void,
			?nonOverlap:TempoUIArrow->Void):Void
	{
		super(x, y);

		reloadText(text);
		reloadBG(this.text, addWidth, addHeight);

		add(this.bg);
		add(this.text);
		add(this.arrowText);

		this.onOverlap = onOverlap;
		this.nonOverlap = nonOverlap;
	}

	private var showTimer:FlxTimer = null;
	private var mouseSelectCount:Int = 0;

	public var overlaped:Bool = false;

	override function update(elapsed:Float):Void
	{
		final overlapedBG:Bool = TempoInput.cursorOverlaps(bg, this.cameras[this.cameras.length - 1]);

		if (this.visible && working)
		{
			overlaped = overlapedBG;

			if (overlapedBG)
			{
				bg.alpha = 0.6;
				text.alpha = 1.0;
				arrowText.alpha = 1.0;

				if (mouseSelectCount < 1)
				{
					mouseSelectCount = 0;

					if (showTimer != null)
						showTimer.cancel();

					for (addTimer in _addTimers)
						if (addTimer != null)
							addTimer.cancel();

					showTimer = new FlxTimer().start(0.25, (tmr:FlxTimer) ->
					{
						tmr = null;

						if (onOverlap != null)
							onOverlap(this);
						if (broadcastToUI)
							TempoUI.event(TempoUIEvents.UI_ARROW_OVERLAP, this);
						trace('showed!');
					});

					TempoUI.cursor(Pointer);

					if (broadcastToUI)
						TempoUI.focus(true, this);

					mouseSelectCount++;
				}
			}
			else
			{
				bg.alpha = 0.2;
				text.alpha = 0.6;
				arrowText.alpha = .6;

				if (mouseSelectCount == 1)
				{
					if (showTimer != null)
						showTimer.cancel();

					TempoUI.cursor();

					if (broadcastToUI)
						TempoUI.focus(false, this);

					mouseSelectCount = 0;
				}
			}
		}

		super.update(elapsed);
	}

	function reloadText(v:String):FlxText
	{
		text = new FlxText(2.5, 2.5, 500, v.toTitleCase(), 16);
		text.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, LEFT, OUTLINE);
		text.fieldWidth = text.textField.textWidth + 7.5;
		text.scale.set(0.925, 0.925);
		text.alpha = 0.6;
		text.updateHitbox();

		return text;
	}

	function reloadArrowText():FlxText
	{
		var isLoaded = false;
		if (arrowText != null)
		{
			isLoaded = true;
			remove(arrowText);
		}

		arrowText = new FlxText(0, 2.5, 500, '>', 16);
		if (bg != null)
			arrowText.x = 0 + bg.width - (arrowText.textField.textWidth + 2.5);
		arrowText.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, RIGHT, OUTLINE);
		arrowText.fieldWidth = arrowText.textField.textWidth + 7.5;
		arrowText.scale.set(.925, .925);
		arrowText.alpha = .6;
		arrowText.updateHitbox();

		if (isLoaded)
			add(arrowText);

		return arrowText;
	}

	function changeBGSize(?w:Float, ?h:Float):TempoSprite
	{
		if (bg != null)
		{
			bg.makeRoundRect({
				width: (w != null ? w : bg.width),
				height: (h != null ? h : bg.height),
				color: TempoUIConstants.COLOR_BUTTON,
				roundRect: {elWidth: 10, elHeight: 10}
			});
			bg.updateHitbox();

			reloadArrowText();

			return bg;
		}

		return null;
	}

	function reloadBG(leText:FlxText, addW:Float, addH:Float):TempoSprite
	{
		bg = new TempoSprite().makeRoundRect({
			width: leText.fieldWidth + 2.5 + addW,
			height: leText.textField.textHeight + 2.5 + addH,
			color: TempoUIConstants.COLOR_BUTTON,
			roundRect: {elWidth: 10, elHeight: 10}
		});
		bg.alpha = 0.2;
		bg.updateHitbox();

		reloadArrowText();

		return bg;
	}
}
