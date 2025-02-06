#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(engine.backend.Setup)
class Main extends Sprite
{
	public static var instance:Main;

	static function main():Void
		Lib.current.addChild(new Main());

	function new()
	{
		super();

		instance = this;

		var _init:(?e:Event) -> Void;
		_init = (?e:Event) ->
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, _init);

			engine.backend.Setup.create();
		}

		if (stage == null)
			addEventListener(Event.ADDED_TO_STAGE, _init);
		else
			_init();
	}
}
