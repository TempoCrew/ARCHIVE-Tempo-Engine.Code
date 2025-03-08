package engine.data;

import engine.input.Controls;

class PlayerSettings
{
	public var id(default, null):Int;
	public var controls(default, null):Controls;

	public function new(id:Int):Void
	{
		this.id = id;
		this.controls = new Controls();
	}
}
