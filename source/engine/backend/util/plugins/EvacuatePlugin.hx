package engine.backend.util.plugins;

/**
 * A plugin which adds functionality to press `F4` to immediately transition to the main menu.
 * This is useful for debugging or if you get softlocked or something.
 */
class EvacuatePlugin extends FlxBasic
{
	public function new()
	{
		super();
	}

	public static function initialize():Void
	{
		FlxG.plugins.addPlugin(new EvacuatePlugin());
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F4)
		{
			FlxG.switchState(() -> new funkin.ui.menus.MainMenuState());
		}
	}

	public override function destroy():Void
	{
		super.destroy();
	}
}
