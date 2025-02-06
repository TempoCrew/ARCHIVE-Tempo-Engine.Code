package tempo.tjson;

#if tjson
class TempoStyle implements tjson.interfaces.EncodeStyle
{
	public var tab(default, null):String;

	public function new(tab:String = " ")
	{
		this.tab = tab;
		charTimesNCache = [""];
	}

	public function beginObject(depth:Int):String
		return '\r{\n';

	public function endObject(depth:Int):String
		return '\n${charTimesN(depth)}}';

	public function keyValueSeperator(depth:Int):String
		return ": ";

	public function firstEntry(depth:Int):String
		return '${charTimesN(depth + 1)}';

	public function entrySeperator(depth:Int):String
		return '\t\n${charTimesN(depth + 1)},';

	public function beginArray(depth:Int):String
		return "[\n";

	public function endArray(depth:Int):String
		return '\n${charTimesN(depth)}]';

	@:private var charTimesNCache:Array<String> = null;

	private function charTimesN(depth:Int):String
		return (depth < charTimesNCache.length ? charTimesNCache[depth] : charTimesNCache[depth] = charTimesN(depth - 1) + tab);
}
#else
typedef TempoStyle = {}
#end
