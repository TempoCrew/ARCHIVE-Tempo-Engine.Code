package tempo.ui;

import flixel.group.FlxSpriteGroup;

class TempoUISlider extends FlxSpriteGroup implements ITempoUI
{
	public var name:String;
	public var broadcastToUI:Bool;
	public var overlaped:Bool;
}

enum SliderType
{
	LEFT_TO_RIGHT;
	RIGHT_TO_LEFT;
	UPPER_TO_BOTTOM;
	BOTTOM_TO_UPPER;
}
