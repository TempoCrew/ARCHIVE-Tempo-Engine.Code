package funkin.ui.menus;

class MainMenuState extends MusicBeatState
{
	override function create():Void
	{
		var bg:TempoSprite = new TempoSprite(-1, -1, GRAPHIC);
		bg.makeImage({path: Paths.image('menuBG')});
		bg.scrollFactor.set();
		add(bg);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
