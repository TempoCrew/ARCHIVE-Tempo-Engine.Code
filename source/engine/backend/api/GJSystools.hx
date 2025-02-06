package engine.backend.api;

#if (systools && FEATURE_GAMEJOLT_CLIENT)
import systools.win.Tools;

typedef FuckInfo =
{
	var os:String;
	var cmds:String;
	var app:String;
	var workdir:String;
}

@:keep
@:access(engine.backend.api.GameJoltClient)
class GJSystools
{
	static var fuck:FuckInfo = null;

	static function restart():Void
	{
		// args fuck
		fuck = {
			os: Sys.systemName(),
			cmds: "Test.hx",
			app: Sys.programPath(),
			workdir: Sys.getCwd()
		};

		GameJoltClient.print(fuck.app);

		final result:Int = Tools.createProcess(fuck.app, fuck.cmds, fuck.workdir, false, false);
		if (result == 0)
		{
			GameJoltClient.print('RESTARTING NOW!');
			Sys.exit(1337);
		}
		else
			throw "Fail for restarting the game!";
	}
}
#end
