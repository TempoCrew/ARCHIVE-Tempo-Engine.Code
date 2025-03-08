package funkin.objects;

class Checkboxer extends FlxSpriteGroup
{
	public var checkbox:TempoSprite;
	public var texter:AtlasText;
	public var name:String = "";
	public var value:Bool = false;
	public var onCallback:Bool->Void = null;
	public var working:Bool = true;

	final _selectPos:FlxPoint;
	final _selectingPos:FlxPoint;
	final _selectorPos:FlxPoint;

	public function new(x:Float, y:Float, name:String, defaultValue:Bool, ?onCallback:Bool->Void):Void
	{
		super(x, y);

		this.name = name;
		this.value = defaultValue;
		this.onCallback = onCallback;

		checkbox = new TempoSprite(x, y, ANIMATE).makeSparrowAtlas({
			path: Paths.image('checkboxThingie'),
			animations: [
				{name: "selected", prefix: "Check Box Selected Static"},
				{name: "selecting", prefix: "Check Box selecting animation"},
				{name: "unselected", prefix: "Check Box unselected"},
			]
		});
		add(checkbox);

		_selectPos = new FlxPoint(checkbox.x, checkbox.y);
		_selectingPos = new FlxPoint(checkbox.x - 20, checkbox.y - 65);
		_selectorPos = new FlxPoint(checkbox.x - 40, checkbox.y - 85);

		checkbox.animation.onFinish.add((anim:String) ->
		{
			if (anim == 'selecting')
			{
				if (value == true)
					checkbox.animation.play('selected');
				else
					checkbox.animation.play('unselected');
			}
		});

		texter = new AtlasText(this.x + this.checkbox.frameWidth, this.y, name);
		add(texter);
	}

	override function update(elapsed:Float):Void
	{
		if (checkbox.animation != null)
		{
			if (checkbox.animation.curAnim != null
				&& checkbox.animation.exists('selected')
				&& checkbox.animation.exists('selecting')
				&& checkbox.animation.exists('unselected'))
			{
				if (checkbox.animation.curAnim.name == 'selected')
				{
					checkbox.x = _selectingPos.x;
					checkbox.y = _selectingPos.y;
				}
				else if (checkbox.animation.curAnim.name == 'selecting')
				{
					checkbox.x = _selectorPos.x;
					checkbox.y = _selectorPos.y;
				}
				else if (checkbox.animation.curAnim.name == "unselected")
				{
					checkbox.x = _selectPos.x;
					checkbox.y = _selectPos.y;
				}
			}

			if (getTempoState()?.player1?.controls?.ACCEPT && working == true)
			{
				value = !value;
				if (onCallback != null)
					onCallback(value);

				checkbox.animation.play('selecting', false, !value);
			}
		}

		super.update(elapsed);
	}

	function getTempoState():TempoState
	{
		var state:TempoState = null;
		if ((FlxG.state is TempoState))
			state = cast FlxG.state;

		return state;
	}
}
