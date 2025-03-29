package funkin.ui.options;

import funkin.ui.menus.OptionsState;
import funkin.objects.TextMenuList.TextMenuItem;

@:access(funkin.ui.menus.OptionsState)
class ControlsSubState extends MusicBeatSubState
{
	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Options Menu", state: "Controls"});
		#end

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 80, 80, true, FlxColor.WHITE, FlxColor.TRANSPARENT));
		grid.alpha = .001;
		grid.velocity.set(40, 40);
		grid.scrollFactor.set();
		FlxTween.tween(grid, {alpha: .25}, 0.4, {ease: FlxEase.quadInOut});
		add(grid);

		var item:TextMenuItem = new TextMenuItem(25, 25, 'Controls', BOLD);
		item.scrollFactor.set();
		item.alpha = 1.;
		add(item);

		super.create();
	}

	override function close():Void
	{
		OptionsState.instance.itemsReturn();

		super.close();
	}

	override function update(elapsed:Float):Void
	{
		if (player1.controls.BACK)
		{
			Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu.ogg')));
			close();
		}

		super.update(elapsed);
	}
}
