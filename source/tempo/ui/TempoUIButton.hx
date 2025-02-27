package tempo.ui;

import flixel.group.FlxSpriteGroup;

class TempoUIButton extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "ui_button";
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
	 * Button key-bind for call `onCallback` variable.
	 */
	public var bindText:Null<FlxText> = null;

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
			if (bindText != null)
				bindText.color = FlxColor.GRAY;
		}

		return v;
	}

	/**
	 * Clicking call function.
	 */
	public var onCallback:Null<TempoUIButton->Void> = null;

	public var onOverlap:Null<TempoUIButton->Void> = null;

	public var overlaped:Bool = false;

	public function new(x:Float, y:Float, text:String, ?addWidth:Float = 0, ?addHeight:Float, ?onCallback:TempoUIButton->Void, ?keyBind:String = null):Void
	{
		super(x, y);

		reloadText(text);
		if (keyBind != null)
			reloadBindText(keyBind);
		reloadBG(this.text, addWidth, addHeight);

		add(this.bg);
		add(this.text);
		if (keyBind != null)
			add(this.bindText);

		this.onCallback = onCallback;
	}

	private var mouseSelectCount:Int = 0;

	override function update(elapsed:Float):Void
	{
		final overlapedBG:Bool = TempoInput.cursorOverlaps(bg, this.cameras[this.cameras.length - 1]);

		if (this.visible && working)
		{
			overlaped = overlapedBG;

			if (overlapedBG)
			{
				bg.alpha = (TempoInput.cursorPressed ? 1.0 : 0.6);
				text.alpha = 1.0;
				if (bindText != null)
					bindText.alpha = 1.0;

				if (TempoInput.cursorJustReleased)
				{
					if (onCallback != null)
						onCallback(this);
					if (broadcastToUI)
						TempoUI.event(TempoUIEvents.UI_BUTTON_CLICKING, this);
				}

				if (mouseSelectCount < 1)
				{
					mouseSelectCount = 0;

					if (onOverlap != null)
						onOverlap(this);

					// CoolStuff.cursor(BUTTON);
					if (broadcastToUI)
						TempoUI.focus(true, this);

					mouseSelectCount++;
				}
			}
			else
			{
				bg.alpha = 0.2;
				text.alpha = 0.6;
				if (bindText != null)
					bindText.alpha = .6;

				if (mouseSelectCount == 1)
				{
					// CoolStuff.cursor(ARROW);
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

	private var parentBindText:FlxText = null;

	function reloadBindText(v:String, ?newX:Float, ?newY:Float):FlxText
	{
		var isReloadedBefore:Bool = false;
		if (bindText != null)
		{
			isReloadedBefore = true;
			parentBindText = bindText;
			remove(bindText);
		}

		bindText = new FlxText((newX != null ? newX : 0), (newY != null ? newY : 2.5), 500, v, 16);

		if (newX == null)
		{
			if (!isReloadedBefore)
				bindText.x = text.textField.textWidth + 20;
			else
			{
				bindText.x = 0 + bg.width - parentBindText.textField.textWidth;

				if (bindText.text.length >= 5 && bindText.text.length <= 6)
					bindText.x -= 7.5;
				else if (bindText.text.length < 5)
					bindText.x -= 5;
			}
		}

		bindText.setFormat(TempoUIConstants.FONT, 16, (text != null ? engine.backend.util.SpriteUtil.dominantColor(text) : TempoUIConstants.COLOR_BASE_TEXT),
			RIGHT, OUTLINE);
		bindText.fieldWidth = bindText.textField.textWidth + 7.5;
		bindText.scale.set(.925, .925);
		bindText.alpha = .6;
		bindText.updateHitbox();

		if (isReloadedBefore)
			add(bindText);

		return bindText;
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

			return bg;
		}

		return null;
	}

	function reloadBG(leText:FlxText, addW:Float, addH:Float):TempoSprite
	{
		bg = new TempoSprite().makeRoundRect({
			width: leText.fieldWidth + (bindText != null ? (bindText.fieldWidth + 7.5) : 0) + 2.5 + addW,
			height: leText.textField.textHeight + 2.5 + addH,
			color: TempoUIConstants.COLOR_BUTTON,
			roundRect: {
				elWidth: 10,
				elHeight: 10
			}
		});
		bg.alpha = 0.2;
		bg.updateHitbox();

		return bg;
	}
}
