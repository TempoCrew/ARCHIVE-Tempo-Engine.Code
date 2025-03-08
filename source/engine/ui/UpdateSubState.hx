package engine.ui;

class UpdateSubState extends MusicBeatSubState
{
	var n:String;
	var o:Void->Void;

	public function new(name:String, onCallback:Void->Void):Void
	{
		super();

		this.n = name;
		this.o = onCallback;
	}

	override function create():Void
	{
		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
