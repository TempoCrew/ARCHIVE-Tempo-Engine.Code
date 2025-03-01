package funkin.ui.menus;

class TrophiesState extends MusicBeatState
{
	override function create():Void
	{
		var bg = new TempoSprite(-5, -5, GRAPHIC).makeImage({
			path: Paths.image('menuDesat'),
			width: 1290,
			height: 730,
			color: FlxColor.PURPLE
		});
		bg.scrollFactor.set();
		add(bg);

		var mainText:FlxText = new FlxText(Constants.SETUP_GAME.width / 3.4, 100, FlxG.width, "Trophies", 32);
		mainText.setFormat(Paths.font('phantomMuff_Bold.ttf'), 32, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		mainText.scrollFactor.set();
		add(mainText);

		var blankBG:TempoSprite = new TempoSprite(mainText.x, mainText.y + 40, ROUND_RECT).makeRoundRect({
			width: 525,
			height: 175,
			color: FlxColor.BLACK,
			roundRect: {
				elWidth: 10,
				elHeight: 10
			}
		});
		blankBG.alpha = .6;
		blankBG.scrollFactor.set();
		add(blankBG);

		var blankImage:TempoSprite = new TempoSprite(0, 0, GRAPHIC).makeImage({
			path: Paths.trophies("images/thx-for-using")
		});
		blankImage.x -= 0;
		blankImage.y = blankBG.y + 10;
		blankImage.scrollFactor.set();
		add(blankImage);

		var blankText:FlxText = new FlxText(blankImage.x + blankImage.width + 10, blankImage.y, blankBG.width - (blankImage.width + 30), "THX For Using", 16);
		blankText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		blankText.scrollFactor.set();
		add(blankText);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
