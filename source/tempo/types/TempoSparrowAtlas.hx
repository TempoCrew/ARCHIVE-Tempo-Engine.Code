package tempo.types;

typedef TempoSparrowAtlas =
{
	path:String,
	animations:Array<TempoAnimData>,
	mainAnim:String,
	?antialiasing:Bool,
	?cache:Bool,
}
