package funkin.backend.song;

/**
 * Charting data
 */
typedef ChartFile =
{
	var scrollSpeeds:Map<String, Float>;
	var notes:Map<String, Array<ChartNoteData>>;
	var sections:Map<String, Array<ChartSectionData>>;
	var ?events:Map<String, Array<ChartEventData>>;
}

typedef ChartSectionData =
{
	beats:Float,
	?bpm:Float,
	?changeBPM:Bool
}

/**
 * Data for event chart-time data
 *
 * Example:
 * ```json
 * "events": {
 *     "easy": [
 *         {
 *             "t": 0,
 *             "n": "Example",
 *             "v": {f: "Hello", s: "World"}
 *         }
 *     ]
 * }
 * ```
 */
typedef ChartEventData =
{
	t:Float,
	n:String,
	v:Dynamic
}

/**
 * Data for note chart-time data
 *
 * Example:
 * ```json
 * "notes": {
 *    "easy": [
 *        {
 *            "t": 0,
 *            "i": 4,
 *            "l": 72.3231,
 *            "c": "Alt Animation",
 *            "v": "-alt"
 *        }
 *    ]
 * }```
 */
typedef ChartNoteData =
{
	/**
	 * Time
	 */
	t:Float,

	/**
	 * Index
	 */
	i:Int,

	/**
	 * Length
	 */
	?l:Float,
	/**
	 * Custom Type
	 */
	?c:String,
	/**
	 * Type value
	 */
	?v:Dynamic
}
