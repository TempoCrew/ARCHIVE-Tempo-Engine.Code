package engine.ui;

import funkin.objects.Checkboxer;

class WarningState extends MusicBeatState
{
	final displayText:String = "*Hey!*\nThis engine contains a #Flashing Lights#, $Screen Shake$ and %Explicit Content%!\n\nEdit below what the game will look like.";
	var text:FlxText;

	override function create():Void
	{
		var bg:FlxSprite = new FlxSprite(-1, -1).makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.fromString('0x170C1D'));
		bg.scrollFactor.set();
		add(bg);

		text = new FlxText(0, 0, FlxG.width, displayText, 32);
		text.setFormat(Paths.font('phantomMuff.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);

		final hey:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW, true, false, FlxColor.WHITE, false), "*");
		final flash:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0x5FFFD7'), true, false, FlxColor.BLACK,
			true), "#");
		final shake:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xFF7A7A'), true, false, FlxColor.BLACK,
			true), "$");
		final exp:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xA341FF'), true, false, FlxColor.BLACK, true),
			"%");

		text.applyMarkup(displayText, [hey, flash, shake, exp]);
		text.scrollFactor.set();
		text.screenCenter(X);
		text.y += 100;
		add(text);

		spawnCheckbox(25, 'Flashing Lights', Save.optionsData.flashing, (b:Bool) -> Save.optionsData.flashing = b);
		spawnCheckbox(500, 'Screen Shake', Save.optionsData.shaking, (b:Bool) -> Save.optionsData.shaking = b);
		spawnCheckbox(850, 'Explicit Content', Save.optionsData.explicit, (b:Bool) -> Save.optionsData.explicit = b);

		var checkW:TempoUICheckbox = new TempoUICheckbox(FlxG.width - 200, 650, "Do not show again", !Save.optionsData.warningVisible, false, (b:Bool) ->
		{
			Save.optionsData.warningVisible = !b;
		});
		checkW.scrollFactor.set();
		add(checkW);

		var button:TempoUIButton = new TempoUIButton(0, 0, "Continue", 5, 0, (b:TempoUIButton) ->
		{
			b.working = false;

			if (Save.optionsData.flashing)
				FlxFlicker.flicker(b, 1, 0.06, false, false);

			trace(Save.optionsData);
			Save.save([OPTIONS]);

			new FlxTimer().start(1, (_) ->
			{
				TempoState.switchState(new funkin.ui.menus.TitleState());
			});
		});
		button.screenCenter();
		button.y += 175;
		button.text.x += 4.5;
		button.scrollFactor.set();
		add(button);

		super.create();
	}

	var checkMap:Array<Checkboxer> = [];

	function spawnCheckbox(xx:Float, n:String, d:Bool, o:Bool->Void):Void
	{
		var checker:Checkboxer = new Checkboxer(xx, text.y + text.height - 100, n, d, o);
		checker.scrollFactor.set();
		checker.working = false;
		add(checker);
		checkMap.push(checker);
	}

	var curSelect:Int = 0;
	var continued:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (!continued)
		{
			if (player1.controls.UI_LEFT_P)
				changeSelection(-1);
			if (player1.controls.UI_RIGHT_P)
				changeSelection(1);
		}

		super.update(elapsed);
	}

	function changeSelection(add:Int = 0):Void
	{
		if (checkMap[curSelect] != null)
		{
			checkMap[curSelect].working = false;
			checkMap[curSelect].alpha = .6;
		}

		curSelect += add;

		if (curSelect < 0)
			curSelect = 2;
		if (curSelect >= 2)
			curSelect = 0;

		if (checkMap[curSelect] != null)
		{
			checkMap[curSelect].working = true;
			checkMap[curSelect].alpha = 1.0;
		}
	}
}
