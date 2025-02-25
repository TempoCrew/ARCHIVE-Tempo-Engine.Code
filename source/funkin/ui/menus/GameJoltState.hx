package funkin.ui.menus;

import gamejolt.formats.User;
import gamejolt.formats.Response;
import flixel.FlxState;

@:access(engine.backend.api.GameJoltClient)
class GameJoltState extends FlxState
{
	var bg:TempoSprite;
	var textDo2:FlxInputText;

	override function create():Void
	{
		bg = new TempoSprite(-5, -5, GRAPHIC).makeImage({
			path: Paths.image('menuDesat'),
			width: 1290,
			height: 730,
			color: FlxColor.PURPLE
		});
		bg.scrollFactor.set();
		add(bg);

		var bottomText:FlxText = new FlxText(5, FlxG.height - 37, FlxG.width, "GameJolt Intergration v0.1.0\nLog in to GameJolt", 16);
		bottomText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		bottomText.scrollFactor.set();
		add(bottomText);

		var blank:TempoSprite = new TempoSprite(0, 0, ROUND_RECT).makeRoundRect({
			width: 525,
			height: 495,
			color: FlxColor.fromString('0x70103629'),
			roundRect: {
				elWidth: 10,
				elHeight: 10
			}
		});
		blank.screenCenter();
		add(blank);

		var blankT:FlxText = new FlxText(0, blank.y + 50, 525, "GAME%JOLT%", 46);
		blankT.setFormat(Paths.font('GameJoltInspired.ttf'), 46, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		blankT.applyMarkup("GAME$JOLT$", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.LIME), "$")]);
		blankT.scrollFactor.set();
		blankT.screenCenter(X);
		add(blankT);

		if (!GameJoltClient.sessionOpened)
		{
			var bgT1:TempoSprite = new TempoSprite(0, 0, ROUND_RECT).makeRoundRect({
				width: 500,
				height: 32,
				color: FlxColor.fromString('0x7F2C0526'),
				roundRect: {
					elWidth: 10,
					elHeight: 10
				}
			});
			bgT1.screenCenter();
			bgT1.y -= 52;
			add(bgT1);

			var textDo1:FlxInputText = new FlxInputText(0, 0, 495, "", 30, FlxColor.WHITE, FlxColor.TRANSPARENT);
			textDo1.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE);
			textDo1.screenCenter();
			textDo1.y -= 51;
			add(textDo1);

			var text1:FlxText = new FlxText(textDo1.x, textDo1.y - 28, 500, "USER", 20);
			text1.setFormat(Paths.font('GameJoltInspired.ttf'), 20, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.fromString('0x7F111F16'));
			add(text1);

			// TOKEN

			var bgT2:TempoSprite = new TempoSprite(0, 0, ROUND_RECT).makeRoundRect({
				width: 500,
				height: 32,
				color: FlxColor.fromString('0x7F2C0526'),
				roundRect: {
					elWidth: 10,
					elHeight: 10
				}
			});
			bgT2.screenCenter();
			bgT2.y += 20;
			add(bgT2);

			textDo2 = new FlxInputText(0, 0, 495, "", 30, FlxColor.WHITE, FlxColor.TRANSPARENT);
			textDo2.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE);
			textDo2.passwordMode = true;
			textDo2.screenCenter();
			textDo2.y += 21;
			add(textDo2);

			var text2:FlxText = new FlxText(textDo2.x, textDo2.y - 28, 500, "TOKEN", 20);
			text2.setFormat(Paths.font('GameJoltInspired.ttf'), 20, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.fromString('0x7F111F16'));
			add(text2);

			final buttWid:Float = (blank.width / 3) - 10;
			final buttHei:Float = 40;

			var button1:GJButton = new GJButton(0, (textDo2.y + textDo2.height) + 20, buttWid, buttHei, FlxColor.fromString('0xFF197E46'));
			button1.onClick = () ->
			{
				trace("Clicked...");

				GameJoltClient.instance.login(textDo1.text, textDo2.text, (res:Response) ->
				{
					FlxG.camera.flash();

					new FlxTimer().start(3, (_) ->
					{
						FlxG.resetState();
					});
				});
			};
			button1.screenCenter(X);
			add(button1);

			var button2:GJButton = new GJButton(button1.x - buttWid, (button1.y + button1.height) + 20, buttWid, buttHei, FlxColor.fromString('0xFF175470'));
			add(button2);

			var button3:GJButton = new GJButton((button2.x + button2.width) + buttWid, button2.y, buttWid, buttHei, FlxColor.fromString('0xFF853069'));
			add(button3);
		}
		else
		{
			var avatar:TempoSprite = new TempoSprite(blank.x + 25, (blankT.y + blankT.height) + 25, GRAPHIC).makeImage({
				path: "Resource/gj_user",
				cache: true
			});
			avatar.setGraphicSize(125, 125);
			avatar.updateHitbox();
			add(avatar);

			final userData = TJSON.parse(File.getContent('./Resource/gj_user.dat')).users[0];
			var text:FlxText = new FlxText(avatar.x + avatar.width + 10, avatar.y + 5, 500, '${userData.username.toUpperCase()}', 32);
			text.setFormat(Paths.font('GameJoltInspired.ttf'), 20, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.fromString('0x7F111F16'));
			add(text);
		}

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

private class GJButton extends TempoSprite
{
	public var onClick:Void->Void;

	public function new(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1, color:FlxColor = FlxColor.LIME):Void
	{
		super(x, y, ROUND_RECT);

		this.makeRoundRect({
			width: width,
			height: height,
			color: FlxColor.WHITE,
			roundRect: {
				elWidth: 10,
				elHeight: 10
			}
		});

		this.color = color;
		this.alpha = .6;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (TempoInput.cursorOverlaps(this, this.cameras[this.cameras.length - 1]))
		{
			alpha = 1.0;

			if (TempoInput.cursorJustPressed)
			{
				if (onClick != null)
					onClick();
			}
		}
		else
			alpha = .6;
	}
}
