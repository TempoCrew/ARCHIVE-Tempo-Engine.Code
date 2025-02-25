package engine.ui;

import openfl.filters.BitmapFilter;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import engine.backend.util.SpriteUtil;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
class GameJoltNotification extends Sprite
{
	var bg:Sprite;
	var avatar:Bitmap;
	var dominantColor:Int;

	public function new(avatarBitmap:BitmapData):Void
	{
		super();

		this.x = Lib.application.window.width - 500;
		this.y = Lib.application.window.height - 250;

		Lib.application.window.onResize.add(onResize);

		this.dominantColor = SpriteUtil.dominantBitmapColor(avatarBitmap);

		bg = new Sprite();
		bg.graphics.beginFill(this.dominantColor, 1);
		bg.graphics.drawRoundRect(0, 0, 500, 250, 10, 10);
		bg.graphics.endFill();
		bg.graphics.beginFill(FlxColor.fromString("0x000000").to24Bit(), 0.75);
		bg.graphics.drawRoundRect(10, 10, 480, 230, 10, 10);
		bg.graphics.endFill();
		bg.y += 255;
		addChild(bg);

		avatar = new Bitmap(avatarBitmap, null, true);
		avatar.x += 20;
		avatar.y += 275;
		avatar.width = 210;
		avatar.height = 210;
		avatar.shader = new engine.backend.shaders.Circle();

		/*
			avatar.bitmapData.fillRect(new Rectangle(0, 0, roundRectSize, roundRectSize), 0x0);
			drawRoundRect(false, false);
			avatar.bitmapData.fillRect(new Rectangle(avatar.bitmapData.width - roundRectSize, 0, roundRectSize, roundRectSize), 0x0);
			drawRoundRect(true, false);
			avatar.bitmapData.fillRect(new Rectangle(0, avatar.bitmapData.height - roundRectSize, roundRectSize, roundRectSize), 0x0);
			drawRoundRect(false, true);
			avatar.bitmapData.fillRect(new Rectangle(avatar.bitmapData.width - roundRectSize, avatar.bitmapData.height - roundRectSize, roundRectSize,
				roundRectSize), 0x0);
			drawRoundRect(true, true); */
		addChild(avatar);

		FlxTween.tween(bg, {y: bg.y - 255}, 0.7, {ease: FlxEase.quadInOut});
		FlxTween.tween(avatar, {y: avatar.y - 255}, 0.7, {ease: FlxEase.quadInOut});
	}

	final roundRectSize:Int = 11;

	function drawRoundRect(invertX:Bool, invertY:Bool):Void
	{
		var antiPoint:FlxPoint = FlxPoint.get((avatar.bitmapData.width - roundRectSize), invertY ? (avatar.bitmapData.height - 1) : 0);

		if (invertY)
			antiPoint.y -= 2;

		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 1), Math.floor(Math.abs(antiPoint.y - 8)), 10, 3), this.dominantColor);

		if (invertY)
			antiPoint.y += 1;

		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 2), Math.floor(Math.abs(antiPoint.y - 6)), 9, 2), this.dominantColor);

		if (invertY)
			antiPoint.y += 1;

		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 3), Math.floor(Math.abs(antiPoint.y - 5)), 8, 1), this.dominantColor);
		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 4), Math.floor(Math.abs(antiPoint.y - 4)), 7, 1), this.dominantColor);
		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 5), Math.floor(Math.abs(antiPoint.y - 3)), 6, 1), this.dominantColor);
		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 6), Math.floor(Math.abs(antiPoint.y - 2)), 5, 1), this.dominantColor);
		avatar.bitmapData.fillRect(new Rectangle((invertX ? antiPoint.x : 8), Math.floor(Math.abs(antiPoint.y - 1)), 3, 1), this.dominantColor);
	}

	function onResize(e1:Int, e2:Int):Void
	{
		trace(e1 + ' / ' + e2);

		this.x = e1 - 500;
		this.y = e2 - 250;
	}
}
