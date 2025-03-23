package funkin.ui.menus;

import flixel.FlxSubState;

@:access(funkin.ui.menus.MainMenuState)
class FreeplaySubState extends MusicBeatSubState
{
	override function create():Void
	{
		FlxG.state.persistentUpdate = false;

		super.create();
	}

	var uiSelected:Bool = false;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!uiSelected)
		{
			if (TempoInput.keyJustPressed.ESCAPE)
			{
				uiSelected = true;
				exit();
			}
		}
	}

	function exit():Void
	{
		MainMenuState.instance.uiSelected = false;
		MainMenuState.instance.menuGrp.forEach((spr:TempoSprite) ->
		{
			FlxTween.tween(spr, {alpha: 1}, 0.1);
			spr.visible = true;
		});

		new FlxTimer().start(1, (t:FlxTimer) ->
		{
			FlxG.state.persistentUpdate = true;
			close();
		});
	}
}
