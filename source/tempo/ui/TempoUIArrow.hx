package tempo.ui;

import flixel.group.FlxSpriteGroup;

class TempoUIArrow extends FlxSpriteGroup implements ITempoUI
{
	public var name:String;
	public var broadcastToUI:Bool;
	public var overlaped:Bool;
	public var ignoreErrors:Bool;
}
