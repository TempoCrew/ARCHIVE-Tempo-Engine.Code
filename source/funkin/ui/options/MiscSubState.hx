package funkin.ui.options;

import funkin.ui.options.backend.Setting;

class MiscSubState extends BaseSubState
{
	final options:Array<Setting> = [
		Setting.get('Warning Screen', "Warning screen will show in start.", "Turn OFF - for those who want to play directly from the title screen.", BOOL,
			"warningVisible"),
		Setting.get('Discord RPC', "Showing your actions in Discord Rich Presence.",
			"Turn OFF - for those who don't use or are embarrassed to show what they are doing in-game.", BOOL, "discordRPC"),
		#if FEATURE_CHECKING_UPDATE
		Setting.get('Checking Updates', "Show the update screen or not?",
			"It is recommended to disable if you do not want to receive notifications about engine/game updatesю", BOOL, "updatesCheck"),
		#end
		Setting.get('Screenshot Encoder', "Screenshot export extension (for optimize or something).", "JPG is recommended for faster export.", STR,
			"screenshotEncoder", ["png", "jpg"])
	];

	public function new()
	{
		this.settings = options;

		super('Miscellaneous');
	}
}
