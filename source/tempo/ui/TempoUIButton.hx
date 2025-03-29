package tempo.ui;

import flixel.group.FlxSpriteGroup;

class TempoUIButton extends FlxSpriteGroup implements ITempoUI
{
	public var name:String;
	public var broadcastToUI:Bool;
	public var overlaped:Bool;
	public var ignoreErrors:Bool;
}
