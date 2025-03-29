package funkin.ui.menus;

class StoryMenuState extends MusicBeatState
{
	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Story Mode"});
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
				Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu', null, false)));
				TempoState.switchState(new MainMenuState());
			}
		}

		super.update(elapsed);
	}
}
