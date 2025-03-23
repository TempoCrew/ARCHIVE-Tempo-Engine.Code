package engine.ui;

import engine.backend.shaders.WhiteOverlay;
import engine.input.Cursor;
import funkin.objects.AtlasText;
import funkin.objects.Checkboxer;

class WarningState extends MusicBeatState
{
	final displayText:String = "*Hey!*\n\nThis engine contains a #Flashing Lights#, $Screen Shake$ and %Explicit Content%!\n\nEdit below what the game will look like.";

	var text:FlxText;
	var checkerMap:Array<Checkboxer> = [];
	var textMap:Array<AtlasText> = [];
	var hitboxMap:Array<FlxSprite> = [];

	var buttonBG:TempoSprite;
	var buttonText:FlxText;
	var blueout:FlxSprite;
	var blackout:FlxSprite;
	var blacktween:FlxTween;
	var bluetween:FlxTween;

	override function create():Void
	{
		var bg:FlxSprite = new FlxSprite(-1, -1).makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.fromString('0x170C1D'));
		bg.scrollFactor.set();
		add(bg);

		text = new FlxText(0, 0, FlxG.width, displayText, 32);
		text.setFormat(Paths.font('phantomMuff.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);

		final hey:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW, true, false, FlxColor.PURPLE, false), "*");
		final flash:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0x5FFFD7'), true, false, FlxColor.BLACK,
			true), "#");
		final shake:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xFF7A7A'), true, false, FlxColor.BLACK,
			true), "$");
		final exp:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xA341FF'), true, false, FlxColor.BLACK, true),
			"%");

		text.applyMarkup(displayText, [hey, flash, shake, exp]);
		text.scrollFactor.set();
		text.screenCenter(X);
		text.y += 35;
		add(text);

		for (i in 0...3)
		{
			final b:Bool = (i == 0 ? Save.optionsData.flashing : (i == 1 ? Save.optionsData.shaking : (i == 2 ? Save.optionsData.explicit : false)));
			final t:String = (i == 0 ? "Flashing Lights" : (i == 1 ? "  Screen Shake" : (i == 2 ? "Explicit Content" : "")));
			final p:Float = 200;

			var checker:Checkboxer = new Checkboxer(10 + p, (i * 117) + (FlxG.height / 3), b);
			checker.updateHitbox();
			checker.scrollFactor.set();
			checker.alpha = .6;
			add(checker);
			checkerMap.push(checker);

			var hitbox:FlxSprite = new FlxSprite(10 + p, checker.y + 10).makeGraphic(650, 75, FlxColor.TRANSPARENT);
			hitbox.scrollFactor.set();
			hitbox.alpha = .001;
			add(hitbox);
			hitboxMap.push(hitbox);

			var text:AtlasText = new AtlasText(-225 + p, (checker.y - 10), t, BOLD);
			text.updateHitbox();
			text.scrollFactor.set();
			text.alpha = .6;
			add(text);
			textMap.push(text);
		}

		buttonBG = new TempoSprite(0, 620, ROUND_RECT);
		buttonBG.makeRoundRect({
			width: 250,
			height: 50,
			color: Constants.UI_COLOR_BUTTON,
			gfxData: {roundRect: {elWidth: 10, elHeight: 10}}
		});
		buttonBG.screenCenter(X);
		buttonBG.scrollFactor.set();
		buttonBG.updateHitbox();
		buttonBG.shader = new WhiteOverlay();
		add(buttonBG);

		buttonText = new FlxText(0, buttonBG.y + 10, 235, 'Continue', 22);
		buttonText.setFormat(Paths.font('vcr.ttf'), 22, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		buttonText.screenCenter(X);
		buttonText.scrollFactor.set();
		buttonText.updateHitbox();
		add(buttonText);

		blueout = new FlxSprite(-1, -1).makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.fromString('0xFF131564'));
		blueout.scrollFactor.set();
		blueout.updateHitbox();
		blueout.alpha = 1;
		bluetween = FlxTween.tween(blueout, {alpha: .001}, 1.25, {ease: FlxEase.quadInOut});
		add(blueout);

		blackout = new FlxSprite(-1, -1).makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.fromString('0xFF000000'));
		blackout.scrollFactor.set();
		blackout.updateHitbox();
		blackout.alpha = 1;
		blacktween = FlxTween.tween(blackout, {alpha: .001}, 1, {ease: FlxEase.quadInOut});
		add(blackout);

		super.create();

		DiscordClient.instance.changePresence({details: "Warning Menu"});

		Cursor.show();
		changeSelection();
	}

	var curSelect:Int = 0;
	var continued:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (!continued)
		{
			if (player1.controls.UI_UP_P && !TempoInput.cursorMoved)
			{
				changeSelection(curSelect - 1);

				Cursor.hide();
			}

			if (player1.controls.UI_DOWN_P && !TempoInput.cursorMoved)
			{
				changeSelection(curSelect + 1);

				Cursor.hide();
			}

			for (i in 0...hitboxMap.length)
			{
				if (TempoInput.cursorOverlaps(hitboxMap[i]))
				{
					if (TempoInput.cursorMoved)
					{
						changeSelection(i, false);

						Cursor.cursorMode = Pointer;
						Cursor.show();
					}

					if (TempoInput.cursorJustPressed)
						accept();
				}
				else if (TempoInput.cursorOverlaps(buttonBG))
				{
					if (TempoInput.cursorMoved)
					{
						changeSelection(3, false);

						Cursor.cursorMode = Pointer;
						Cursor.show();
					}
					if (TempoInput.cursorJustPressed)
						acceptContinue();
				}
				else
				{
					if (TempoInput.cursorMoved)
						Cursor.cursorMode = Default;
				}
			}

			if (player1.controls.ACCEPT && curSelect != 3 && !TempoInput.cursorMoved)
			{
				accept();

				Cursor.hide();
			}
			else if (player1.controls.ACCEPT && curSelect == 3 && !TempoInput.cursorMoved)
			{
				acceptContinue();
			}
		}

		super.update(elapsed);
	}

	function acceptContinue():Void
	{
		continued = true;

		Save.optionsData.flashing = checkerMap[0].currentValue;
		Save.optionsData.shaking = checkerMap[1].currentValue;
		Save.optionsData.explicit = checkerMap[2].currentValue;
		Save.save([OPTIONS]);

		buttonBG.angle = FlxG.random.float(-30, 30);
		buttonText.angle = buttonBG.angle;
		buttonBG.scale.set(1.2, 1.2);
		buttonText.scale.set(1.2, 1.2);
		FlxTween.tween(buttonBG, {angle: 0}, 0.4, {ease: FlxEase.quartOut});
		FlxTween.tween(buttonBG.scale, {x: 1.0, y: 1.0}, 0.4, {ease: FlxEase.quartOut});
		FlxTween.tween(buttonText, {angle: 0}, 0.4, {ease: FlxEase.quartOut});
		FlxTween.tween(buttonText.scale, {x: 1.0, y: 1.0}, 0.4, {ease: FlxEase.quartOut});

		buttonBG.shader.data.progress.value = [1.0];
		FlxTween.num(1.0, 0.0, 0.7, {ease: FlxEase.quadOut}, (v:Float) ->
		{
			buttonBG.shader.data.progress.value = [v];
		});

		Tempo.playSound(Paths.loader.sound(Paths.sound('confirmMenu.${Constants.EXT_SOUND}')));

		if (Save.optionsData.flashing)
		{
			for (c in checkerMap)
				FlxFlicker.flicker(c, 1, .06, false, false);
			for (c in textMap)
				FlxFlicker.flicker(c, 1, .06, false, false);

			FlxFlicker.flicker(text, 1, .1, false, false);
			FlxFlicker.flicker(buttonText, 1, .1, false, false);
		}

		if (bluetween != null)
			bluetween.cancel();

		if (blacktween != null)
			blacktween.cancel();

		bluetween = FlxTween.tween(blueout, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		blacktween = FlxTween.tween(blackout, {alpha: 1}, 1.05, {
			ease: FlxEase.quadInOut,
			onComplete: (t:FlxTween) ->
			{
				t = null;
				TempoState.switchState(new funkin.ui.menus.TitleState());
			}
		});

		Cursor.hide();
	}

	function accept():Void
	{
		checkerMap[curSelect].currentValue = !checkerMap[curSelect].currentValue;
		Tempo.playSound(Paths.loader.sound(Paths.sound((checkerMap[curSelect].currentValue ? 'scrollMenu.${Constants.EXT_SOUND}' : 'cancelMenu.${Constants.EXT_SOUND}'))));
	}

	function changeSelection(add:Int = 0, ?snd:Bool = true):Void
	{
		if (snd)
			Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu.${Constants.EXT_SOUND}')), .7);

		if (checkerMap[curSelect] != null)
			checkerMap[curSelect].alpha = .6;
		if (textMap[curSelect] != null)
			textMap[curSelect].alpha = .6;

		curSelect = add;

		if (curSelect < 0)
			curSelect = 3;
		if (curSelect >= 4)
			curSelect = 0;

		if (curSelect == 3)
		{
			buttonBG.alpha = 1;
			buttonText.alpha = 1;
		}
		else
		{
			buttonBG.alpha = .6;
			buttonText.alpha = .6;
		}

		if (checkerMap[curSelect] != null)
			checkerMap[curSelect].alpha = 1;
		if (textMap[curSelect] != null)
			textMap[curSelect].alpha = 1;
	}
}
