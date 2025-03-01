package funkin.objects;

// TODO: Character for playing (or else)
// 1. Display and control in gameplay menu (PlayState)
// 2. Create a data file for this object.
// 3. Support with Character/Stage (and many) Editors
// 4. Support a FlxAnimate
// 5. Support a Multi-Paths for this object (how many files with animations, will be displayed in this object?)
// 6. To be continued in Character Editor TODO list...
class Character extends TempoSprite
{
	public function new():Void
	{
		super(0, 0, ANIMATE);
	}
}
