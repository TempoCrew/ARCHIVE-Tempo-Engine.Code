package tempo.ui;

import flixel.addons.ui.FlxSlider;
import flixel.group.FlxSpriteGroup;

class TempoUISlider extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "";
	public var broadcastToUI:Bool = true;
	public var overlaped:Bool = false;

	public var bar:TempoSprite;
	public var coloredBar:TempoSprite;
	public var minText:FlxText;
	public var maxText:FlxText;
	public var valueText:FlxText;
	public var selector:TempoSprite;
	public var label(get, set):String;

	function set_label(v:String):String
	{
		labelText.text = v;
		posUpdate();
		return labelText.text;
	}

	function get_label():String
		return labelText.text;

	public var labelText:FlxText;

	public var value(default, set):Float = 0;

	function set_value(v:Float)
	{
		value = Math.max(min, Math.min(max, v));
		valueText.text = '${FlxMath.roundDecimal(value, decimals)}';
		posUpdate();
		return value;
	}

	public var onChange:Float->Void;

	public var min(default, set):Float = -999;

	function set_min(v:Float):Float
	{
		if (v > max)
			max = v;
		min = v;
		minText.text = '${FlxMath.roundDecimal(min, decimals)}';
		posUpdate();
		return min;
	}

	public var max(default, set):Float = 999;

	function set_max(v:Float):Float
	{
		if (v < min)
			min = v;
		max = v;
		maxText.text = '${FlxMath.roundDecimal(max, decimals)}';
		posUpdate();
		return max;
	}

	public var decimals(default, set):Int = 2;

	function set_decimals(v:Int):Int
	{
		decimals = v;

		minText.text = '${FlxMath.roundDecimal(min, decimals)}';
		maxText.text = '${FlxMath.roundDecimal(max, decimals)}';
		valueText.text = '${FlxMath.roundDecimal(value, decimals)}';

		if (this.onChange != null)
			this.onChange(FlxMath.roundDecimal(value, decimals));

		posUpdate();

		return decimals;
	}

	public function new(x:Float, y:Float, callback:Float->Void, defaultValue:Float = 0.0, min:Float = -999, max:Float = 999, width:Float = 200):Void
	{
		super(x, y);
		this.onChange = callback;

		bar = new TempoSprite();
		bar.makeRoundRect({
			width: width,
			height: 5,
			color: FlxColor.GRAY,
			roundRect: {elWidth: 5, elHeight: 5}
		});
		bar.updateHitbox();
		add(bar);

		reloadTexts(width);

		selector = new TempoSprite();
		selector.makeRoundRect({
			width: 5,
			height: 15,
			color: TempoUIConstants.COLOR_SLIDER_SELECTOR,
			roundRect: {elWidth: 5, elHeight: 5}
		});
		selector.updateHitbox();
		add(selector);

		this.min = min;
		this.max = max;
		this.value = defaultValue;
		posUpdate();
		forceNextUpdate = true;
	}

	public var selectorMoved:Bool = false;
	public var opacityChanging:Bool = false;
	public var forceNextUpdate:Bool = false;

	var mouseSelectCount:Int = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (opacityChanging && visible)
		{
			if (TempoInput.cursorOverlaps(this, this.cameras[this.cameras.length - 1]))
			{
				alpha = 1.0;

				if (mouseSelectCount < 1)
				{
					if (broadcastToUI)
						TempoUI.focus(true, this);

					TempoUI.cursor(Pointer);

					mouseSelectCount++;
				}
			}
			else
			{
				alpha = 0.6;

				if (mouseSelectCount == 1)
				{
					if (broadcastToUI)
						TempoUI.focus(false, this);

					TempoUI.cursor();

					mouseSelectCount = 0;
				}
			}
		}

		if (TempoInput.cursorMoved || TempoInput.cursorJustPressed || forceNextUpdate)
		{
			forceNextUpdate = false;

			if (TempoInput.cursorJustPressed
				&& (TempoInput.cursorOverlaps(bar, this.cameras[this.cameras.length - 1])
					|| TempoInput.cursorOverlaps(selector, this.cameras[this.cameras.length - 1])))
				selectorMoved = true;

			if (selectorMoved)
			{
				var parentValue:Float = FlxMath.roundDecimal(value, decimals);

				this.value = Math.max(min, Math.min(max, getCursorMouseValue(this.cameras[this.cameras.length - 1])));

				TempoUI.cursor(Grabbing);

				if (this.onChange != null && parentValue != this.value)
				{
					this.onChange(FlxMath.roundDecimal(this.value, decimals));
					if (broadcastToUI)
						TempoUI.event(TempoUIEvents.UI_SLIDER_CHANGING, this);
				}
			}
		}

		if (TempoInput.cursorReleased)
		{
			if (mouseSelectCount == 1)
				TempoUI.cursor(Pointer);
			else if (mouseSelectCount == 0)
				TempoUI.cursor();

			selectorMoved = false;
		}
	}

	function reloadTexts(width:Float):Void
	{
		minText = new FlxText(0, 0, 80, "", 8);
		minText.alignment = CENTER;
		add(minText);

		maxText = new FlxText(0, 0, 80, "", 8);
		maxText.alignment = CENTER;
		add(maxText);

		valueText = new FlxText(0, 0, 80, "", 8);
		valueText.alignment = CENTER;
		add(valueText);

		labelText = new FlxText(0, 0, width, "", 8);
		labelText.alignment = CENTER;
		add(labelText);
	}

	function posUpdate()
	{
		minText.x = bar.x - minText.width / 2;
		maxText.x = bar.x + bar.width - maxText.width / 2;
		valueText.x = bar.x + bar.width / 2 - valueText.width / 2;
		labelText.x = bar.x + bar.width / 2 - labelText.width / 2;

		if (label.length > 0)
			bar.y = labelText.y + (12 * 2);

		minText.y = maxText.y = valueText.y = bar.y + 12;

		posSelectorUpdate();
	}

	function posSelectorUpdate():Void
	{
		selector.x = bar.x - selector.width / 2 + FlxMath.remapToRange(FlxMath.roundDecimal(value, decimals), min, max, 0, bar.width);
		selector.y = bar.y + bar.height / 2 - selector.height / 2;
	}

	private function getCursorMouseValue(curCamera:FlxCamera):Float
		return FlxMath.remapToRange(TempoInput.cursor.getPositionInCameraView(curCamera).x, bar.x, bar.x + bar.width, min, max);
}

enum SliderType
{
	LEFT_TO_RIGHT;
	RIGHT_TO_LEFT;
	UPPER_TO_BOTTOM;
	BOTTOM_TO_UPPER;
}
