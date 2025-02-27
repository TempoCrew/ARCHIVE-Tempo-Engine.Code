package tempo.ui;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;

// TODO: Finishing
class TempoUIRadio extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "ui_radio";
	public var broadcastToUI:Bool = true;
	public var overlaped:Bool = false;

	public var values:Array<String>;
	public var value(default, set):String = "";

	function set_value(v:String):String
	{
		value = v;

		for (image => text in radioMap)
		{
			if (text.text == v)
			{
				image.animation.play('enable');
			}
			else
				image.animation.play('disable');
		}

		return v;
	}

	public var bgHeight:Float = 0;
	public var bgWidth:Float = 0;

	public var working:Bool = true;

	public function new(x:Float, y:Float, values:Array<String>, defaultValue:String):Void
	{
		super(x, y);

		this.values = values;

		reloadValueTexts();

		for (bg in bgs)
		{
			bgHeight += bg.height;

			add(bg);
		}

		for (image => text in radioMap)
		{
			add(image);
			add(text);
		}

		this.value = defaultValue;
	}

	public var bgs:Array<TempoSprite> = [];
	public var radioMap:Map<TSG, FlxText> = [];

	function reloadValueTexts()
	{
		final graph:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile('engine/materials/radio.${Constants.EXT_DEBUG_IMAGE}'));

		for (i in 0...values.length)
		{
			var bg:TempoSprite = new TempoSprite(0, i * 20);
			bg.alpha = .2;

			var image:TSG = new TSG(2.5 - (16 * 1.5), 2.5 - (16 * 1.5)).graphicLoad('radio', true, Math.floor(graph.width / 2), Math.floor(graph.height));
			image.setGraphicSize(16, 16);
			image.y += i * 20;
			image.zIndex = i;
			image.animation.add('disable', [0], 0, false);
			image.animation.add('enable', [1], 0, false);
			image.animation.play('disable');
			image.antialiasing = Save.optionsData.antialiasing;

			var text:FlxText = new FlxText(16 + 2.5, 2.5, 500, values[i], 16);
			text.y += i * 20;
			text.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, LEFT, OUTLINE);
			text.fieldWidth = text.textField.textWidth + 7.5;

			bg.makeRoundRect({
				width: 25 + text.textField.textWidth,
				height: 20,
				color: TempoUIConstants.COLOR_BUTTON,
				roundRect: {elWidth: 10, elHeight: 10}
			});
			bgs.push(bg);

			if (bg.width > bgWidth)
			{
				bgWidth = bg.width;
			}

			radioMap.set(image, text);
		}

		for (bg in bgs)
			bg.makeRoundRect({
				width: bgWidth,
				height: 20,
				color: TempoUIConstants.COLOR_BUTTON,
				roundRect: {elWidth: 10, elHeight: 10}
			});
	}

	override function update(e:Float):Void
	{
		if (this.visible && working)
		{
			for (image => text in radioMap)
			{
				final overlaped:Bool = TempoInput.cursorOverlaps(bgs[image.zIndex], this.cameras[this.cameras.length - 1]);

				if (overlaped)
				{
					bgs[image.zIndex].alpha = 0.6;

					if (TempoInput.cursorJustReleased)
					{
						value = text.text;
					}
				}
				else
				{
					bgs[image.zIndex].alpha = .2;
				}
			}
		}

		super.update(e);
	}
}
