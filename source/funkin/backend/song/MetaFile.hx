package funkin.backend.song;

typedef MetaFile =
{
	var artist:String;
	var songName:String;
	var bpm:Float;
	var album:String;
	var generatedBy:String;
	var ?charter:String;
	var ?playData:MetaPlayData;
}

/**
 * Meta-Gameplay data
 *
 * Example:
 * ```json
 * "stage": "mainStage",
 * "players": {
 *     "boyfriend": "boyfriend",
 *     "girlfriend": "gf",
 *     "opponent": "dad"
 * },
 * "ratings": {
 *     "easy": 1.0,
 *     "normal": 4,
 *     "hard": 10.321
 * },
 * "difficulties": ["easy", "normal", "hard"],
 * "uiStyle": "funkin",
 * "previewStart": 0,
 * "previewEnd": 12000
 * ```
 */
typedef MetaPlayData =
{
	stage:String,
	players:Map<String, String>,
	ratings:Map<String, Float>,
	difficulties:Array<String>,
	uiStyle:String,
	previewStart:Float,
	previewEnd:Float
}
