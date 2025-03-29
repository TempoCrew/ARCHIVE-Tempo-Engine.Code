package funkin.ui.menus;

class SoundTestState extends MusicBeatState
{
	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Sound Test", type: LISTENING});
		#end

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (player1.controls.BACK)
			TempoState.switchState(new MainMenuState());

		super.update(elapsed);
	}
}
