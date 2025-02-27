package tempo.ui;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;

class TempoUICheckbox extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "ui_checkbox";
	public var broadcastToUI:Bool = true;

	/**
	 * Change this, if this checkbox do not working.
	 */
	public var working(default, set):Bool = true;

	/**
	 * Checkbox animated image variable, here a his animations, frames, graphic data and etc.
	 */
	public var image:Null<TSG> = null;

	/**
	 * Checkbox name text.
	 */
	public var text:Null<FlxText> = null;

	/**
	 * Checkbox value (true or false).
	 */
	public var value(default, set):Bool = false;

	/**
	 * Checkbox image and text background.
	 */
	public var bg:Null<TempoSprite> = null;

	/**
	 * If mouse overlap a checkbox, background and text opacity will changing... or no?
	 */
	public var opacityChanges:Bool = true;

	/**
	 * Checkbox clicking calling function.
	 */
	public var onCallback:Null<Bool->Void> = null;

	/**
	 * `String` text from `text` variable.
	 */
	private var _text:Null<String> = null;

	function set_working(v:Bool):Bool
	{
		working = v;

		if (!v)
		{
			if (image != null)
				image.color = FlxColor.GRAY;
			if (text != null)
				text.color = FlxColor.GRAY;
		}

		return v;
	}

	public var onOverlap:Null<TempoUICheckbox->Void> = null;

	/**
	 * Creating a checkbox UI.
	 * @param x offset X
	 * @param y offset Y
	 * @param text checkbox name
	 * @param defaultValue checkbox default value (false or true)
	 * @param opacityChanges If mouse overlap a checkbox, background and text opacity will changing... or no?
	 * @param onCallback After clicking this checkbox, what happened? (Write `null` or skip to do nothing)
	 */
	public function new(x:Float, y:Float, text:String, defaultValue:Bool, ?opacityChanges:Bool = true, ?onCallback:Bool->Void):Void
	{
		super(x, y);

		this.opacityChanges = opacityChanges;
		this._text = text;

		reloadCheckboxImage();
		reloadCheckboxText();
		reloadCheckboxBG();

		add(bg);
		add(image);
		add(this.text);

		this.value = defaultValue;
		this.onCallback = onCallback;
	}

	/**
	 * IDK how in `update()` it was possible to make the cursor overlap on an object once, and not 10000 times.
	 *
	 * This only one, what i'll maked this idea ㄟ( ▔, ▔ )ㄏ
	 */
	private var mouseSelectCount:Int = 0;

	public var overlaped:Bool = false;

	override function update(elapsed:Float):Void
	{
		final overlapedBG:Bool = TempoInput.cursorOverlaps(this.bg, this.cameras[this.cameras.length - 1]);
		if (this.visible && working)
		{
			overlaped = overlapedBG;

			if (overlapedBG)
			{
				if (opacityChanges)
				{
					bg.alpha = (TempoInput.cursorPressed ? 1.0 : 0.6);
					text.alpha = 1.0;
				}

				if (TempoInput.cursorJustReleased)
				{
					this.value = !this.value;
					if (onCallback != null)
						onCallback(this.value);
					if (broadcastToUI)
						TempoUI.event(TempoUIEvents.UI_CHECKBOX_CLICKING, this);
				}

				if (mouseSelectCount < 1)
				{
					mouseSelectCount = 0;

					if (onOverlap != null)
						onOverlap(this);
					if (broadcastToUI)
						TempoUI.focus(true, this);
					// CoolStuff.cursor(BUTTON);

					mouseSelectCount++;
				}
			}
			else
			{
				if (opacityChanges)
				{
					bg.alpha = 0.2;
					text.alpha = 0.6;
				}

				if (mouseSelectCount == 1)
				{
					if (broadcastToUI)
						TempoUI.focus(false, this);
					// CoolStuff.cursor(ARROW);

					mouseSelectCount = 0;
				}
			}
		}

		super.update(elapsed);
	}

	function reloadCheckboxImage():TSG
	{
		final graph:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile('engine/materials/checkbox.${Constants.EXT_DEBUG_IMAGE}'));
		image = new TSG(2.5 - (16 * 1.5), 2.5 - (16 * 1.5)).graphicLoad('checkbox', true, Math.floor(graph.width / 2), graph.height);
		image.setGraphicSize(16, 16);
		image.animation.add('disable', [0], 0, false);
		image.animation.add('enable', [1], 1, false);
		image.antialiasing = Save.optionsData.antialiasing;

		return image;
	}

	function reloadCheckboxText():FlxText
	{
		text = new FlxText((image != null ? 16 : 0) + 2.5, 2.5, 500, _text, 16);
		text.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, LEFT, OUTLINE);
		text.fieldWidth = text.textField.textWidth + 7.5;
		text.alpha = (opacityChanges ? 0.6 : 1.0);

		return text;
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

	function reloadCheckboxBG():TempoSprite
	{
		bg = new TempoSprite().makeRoundRect({
			width: (image != null ? 16 + (text != null ? text.textField.textWidth : 0) : 0) + 10,
			height: (image != null ? 16 : 0) + 5,
			color: TempoUIConstants.COLOR_BUTTON,
			roundRect: {
				elWidth: 10,
				elHeight: 10
			}
		});
		bg.alpha = (opacityChanges ? 0.2 : 0.0);

		return bg;
	}

	function set_value(v:Bool):Bool
	{
		this.value = v;

		if (this.image != null)
			this.image.animation.play(v ? 'enable' : 'disable');

		return v;
	}
}
