package tempo.ui;

import flixel.group.FlxSpriteGroup;

class TempoUIList extends FlxSpriteGroup implements ITempoUI
{
	public var name:String;
	public var broadcastToUI:Bool;
	public var overlaped:Bool;
}

@:coreType private enum abstract ListStringType from String to String
{
	var CHECKBOX = "checkbox";
	var BUTTON = "button";
	var ARROW = "arrow";
	var RADIO = "radio";
}
