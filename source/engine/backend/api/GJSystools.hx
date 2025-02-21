package engine.backend.api;

#if (systools && cpp && FEATURE_GAMEJOLT_CLIENT)
import systools.win.Tools;

@:keep
@:access(engine.backend.api.GameJoltClient)
class GJSystools
{
	public function new():Void
	{
		GameJoltClient.print(Sys.programPath());

		final result:Int = Tools.createProcess(Sys.programPath(), "GameJoltClient.hx", Sys.getCwd(), false, false);
		if (result == 0)
		{
			GameJoltClient.print("RESTART SKIBIDI DOP DOP!!");
			System.exit(1337);
		}
		else
			throw "Fail for restarting the game!";
	}
}
#end
