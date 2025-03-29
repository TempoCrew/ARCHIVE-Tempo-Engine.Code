package funkin.ui.options;

class InputOffsetState extends MusicBeatState
{
	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Input Offset Menu"});
		#end

		super.create();
	}

	var uiSelected:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (!uiSelected)
		{
			if (player1.controls.BACK)
			{
				uiSelected = true;
				Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu.ogg')));
				TempoState.switchState(new funkin.ui.menus.OptionsState());
			}
		}

		super.update(elapsed);
	}
}
