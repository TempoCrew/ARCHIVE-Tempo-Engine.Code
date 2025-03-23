#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if (linux && !debug)
@:cppInclude('./engine/external/gamemode_client.h')
@:cppFileCode('#define GAMEMODE_AUTO')
#end
class Main extends Sprite
{
	public static var instance:Main;

	static function main():Void
		Lib.current.addChild(new Main());

	function new()
	{
		super();

		engine.backend.util.SysUtil.setFeatures();
		engine.backend.util.SysUtil.findPath();

		instance = this;

		_i();
	}

	@:default([])
	@:noUsing private function _i():Void
	{
		var _init:(?e:Event) -> Void;
		_init = (?e:Event) ->
		{
			if (hasEventListener("addedToStage"))
				removeEventListener("addedToStage", _init);

			@:privateAccess
			engine.Setup.create();
		}

		if (stage == null)
			addEventListener("addedToStage", _init);
		else
			_init();
	}
}
