package funkin.ui.options;

import funkin.ui.options.backend.Setting;

class PerformanceSubState extends BaseSubState
{
	final options:Array<Setting> = [
		Setting.get("Framerate", "How much will rendering a real-time frames per second?", "It is recommended to put a value under the screen frequency.",
			INT, 'framerate',
			{
				min: 60,
				max: 240
			}),
		Setting.get("FPS Counter", "Show a FPS counter in screen?", "It is recommended to turn it off if you are shooting video.", BOOL, 'fpsCounter'),
		Setting.get("RAM Counter", "Show a RAM counter in screen?", "It is recommended to turn it off if you are shooting video", BOOL, "ramCounter"),
		Setting.get("Flashing Lights", "If you are epileptic and/or don't like flickering things then turn this off!",
			"Recommended to include for cool effects.", BOOL, "flashing"),
		Setting.get("Screen Shake", "If you don't like when screen will shaking, turn off this!", "Recommended to include for cool effects.", BOOL, 'shaking'),
		Setting.get("Explicit", "The game may display abnormal language and/or rude words towards someone.",
			"Recommended to turn off due to abnormal language", BOOL, 'explicit'),
		Setting.get("Anti-Alias", "Smoothing of images in the game.", "It is recommended to turn it off if your PC is weak.", BOOL, "antialiasing"),
		Setting.get("VRAM Caching", "Caching within RAM to ensure fast game performance.", "Recommended for PC with 8 (or highter) RAM.", BOOL, 'cacheVRAM'),
		Setting.get("Shaders", "Shaders act on digital images, also called textures in the field of computer graphics. They modify attributes of pixels.",
			"Recommended for video cards with vulkan technology", BOOL, "shaders")
	];

	public function new()
	{
		this.settings = options;
		super('Performance');
	}
}
