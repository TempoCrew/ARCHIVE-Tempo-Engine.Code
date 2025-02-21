package engine.ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import engine.backend.util.SpriteUtil;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
class GameJoltNotification extends Sprite
{
	var bg:Sprite;
	var avatar:Bitmap;

	public function new(avatarBitmap:BitmapData):Void
	{
		super();

		this.x = Lib.application.window.width - 500;
		this.y = Lib.application.window.height - 250;

		Lib.application.window.onResize.add(onResize);

		bg = new Sprite();
		bg.graphics.beginFill(FlxColor.LIME.to24Bit(), 1);
		bg.graphics.drawRoundRect(0, 0, 500, 250, 10, 10);
		bg.graphics.endFill();
		bg.graphics.beginFill(FlxColor.fromString("0x401166").to24Bit(), 0.75);
		bg.graphics.drawRoundRect(10, 10, 480, 230, 10, 10);
		bg.graphics.endFill();
		bg.y += 255;
		addChild(bg);

		avatar = new Bitmap(avatarBitmap, null, true);
		avatar.x += 20;
		avatar.y += 275;
		avatar.width = 210;
		avatar.height = 210;
		addChild(avatar);

		FlxTween.tween(bg, {y: bg.y - 255}, 0.7, {ease: FlxEase.quadInOut});
		FlxTween.tween(avatar, {y: avatar.y - 255}, 0.7, {ease: FlxEase.quadInOut});
	}

	function onResize(e1:Int, e2:Int):Void
	{
		this.x = e1 - 500;
		this.y = e2 - 250;
	}
}
