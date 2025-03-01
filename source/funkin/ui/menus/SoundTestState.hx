package funkin.ui.menus;

class SoundTestState extends MusicBeatState
{
	override function create():Void
	{
		DiscordClient.instance.changePresence({details: "Sound Test", type: LISTENING});

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (player1.controls.BACK)
			TempoState.switchState(new TitleState(), () ->
			{
				DiscordClient.instance.changePresence({details: "Title", type: PLAYING});
			});

		super.update(elapsed);
	}
}
