package engine.data;

import engine.backend.Inputter;

class PlayerSettings
{
	public var id(default, null):Int;
	public var controls(default, null):Inputter;

	public function new(id:Int):Void
	{
		this.id = id;
		this.controls = new Inputter();
	}
}
