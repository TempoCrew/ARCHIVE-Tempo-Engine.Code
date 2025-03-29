package engine.data.variables;

@:structInit class MainVariables
{
	/**
	 * Level score (1 - level name, 2 - score)
	 */
	public var levelData:Map<String,
		{
			score:Int,
			accuracy:Float,
			rating:String,
			ratingFC:String
		}> = [];

	/**
	 * Song Map Data
	 */
	public var songData:Map<String,
		{
			score:Int,
			accuracy:Float,
			rating:String,
			ratingFC:String
		}> = [];
}
