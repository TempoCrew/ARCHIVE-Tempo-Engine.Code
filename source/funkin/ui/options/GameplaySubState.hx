package funkin.ui.options;

import funkin.ui.options.backend.Setting;

class GameplaySubState extends BaseSubState
{
	final options:Array<Setting> = [
		// Display Name, Display Description, Display Recommendations, Setting Type, Variable from ``Save.optionsData`` (or OptionsVariables.hx), Dynamic Value
		Setting.get("Scroll Position", "What position will the arrows be in? (UpScroll or DownScroll).",
			"Changing to DownScroll is recommended for those who can't get through a song in UpScroll", STR, 'scrollPos', ['UpScroll', 'DownScroll']),
		Setting.get("Middle Scroll", "The player's arrows will be in the center of the screen.",
			"Turn Off - for those who are used to osu!mania or who are not used to the fnf position.", BOOL, 'middleScroll'),
		Setting.get("Safe Frames", "Customize your Hit Offset.", "Recommended for players who play for accuracy.", FLOAT, "safeFrames"),
		Setting.get("Show Opponent Notes", "Show's a opponent strum notes in gameplay?",
			"Turn Off - if you don't want to watch your opponent press the arrows and play without looking back.", BOOL, "enemyStrums")
	];

	public function new()
	{
		this.settings = options;

		super('Gameplay');
	}
}
