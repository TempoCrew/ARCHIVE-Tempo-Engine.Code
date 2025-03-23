package funkin.objects;

class Checkboxer extends TempoSprite
{
	public var currentValue(default, set):Bool;

	public function new(x:Float, y:Float, defaultValue:Bool = false):Void
	{
		super(x, y, ANIMATE);

		makeSparrowAtlas({
			path: Paths.image('checkboxThingie'),
			animations: [
				{name: "static", prefix: "Check Box unselected", looped: false},
				{name: "checked", prefix: "Check Box selecting animation", looped: false}
			]
		});
		setGraphicSize(width * .7);
		updateHitbox();

		checkAntialiasing(null);

		this.currentValue = defaultValue;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		switch (animation.curAnim.name)
		{
			case "static":
				setOffset();
			case "checked":
				setOffset(17, 70);
		}
	}

	function set_currentValue(v:Bool):Bool
	{
		if (v)
			playAnim('checked', true);
		else
			playAnim('static');

		return currentValue = v;
	}
}
