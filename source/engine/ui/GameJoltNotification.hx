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

		Lib.current.stage.application.window.onResize.add(onResize);

		this.x = Lib.current.stage.application.window.width - 500;
		this.y = Lib.current.stage.application.window.height - 250;

		this.dominantColor = SpriteUtil.dominantBitmapColor(avatarBitmap);

		bg = new Sprite();
		bg.graphics.beginFill(this.dominantColor, 1);
		bg.graphics.drawRoundRect(0, 0, 500, 175, 10, 10);
		bg.graphics.endFill();
		bg.graphics.beginFill(FlxColor.BLACK.to24Bit(), 0.75);
		bg.graphics.drawRoundRect(10, 10, 480, 160, 10, 10);
		bg.graphics.endFill();
		bg.y += 200;
		addChild(bg);

		avatar = new Bitmap(avatarBitmap, AUTO, true);
		avatar.x += 20;
		avatar.y += 225;
		avatar.width = 150;
		avatar.height = 150;
		avatar.shader = new engine.backend.shaders.Circle();
		addChild(avatar);

		FlxTween.tween(bg, {y: bg.y - 200}, 0.7, {ease: FlxEase.quadInOut});
		FlxTween.tween(avatar, {y: avatar.y - 200}, 0.7, {ease: FlxEase.quadInOut});

		FlxTween.tween(bg, {y: bg.y + 200}, 0.7, {ease: FlxEase.quadInOut, startDelay: 4});
		FlxTween.tween(avatar, {y: avatar.y + 200}, 0.7, {
			ease: FlxEase.quadInOut,
			startDelay: 4,
			onComplete: (_:FlxTween) ->
			{
				_ = null;
				removeChild(bg);
				removeChild(avatar);
			}
		});
	}

	function onResize(e1:Int, e2:Int):Void
	{
		this.x = Lib.current.stage.application.window.width - 500;
		this.y = Lib.current.stage.application.window.height - 250;
	}
}
