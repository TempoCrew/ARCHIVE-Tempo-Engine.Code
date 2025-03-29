package engine.objects;

#if desktop
import flixel.util.FlxStringUtil;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

/**
 * FPS/RAM (and text stuffs) in here.
 */
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Counters extends TextField
{
	/**
	 * Current frame rate.
	 */
	public var curFPS(default, null):Int;

	/**
	 * Current ram memory from game.
	 */
	public var curRAM(default, null):Float;

	@:noCompletion var peakRAM:Float;
	@:noCompletion var cacheCount:Int;
	@:noCompletion var curTime:Float;
	@:noCompletion var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:UInt = 0x000000):Void
	{
		super();

		this.x = x;
		this.y = y;

		curFPS = 0;
		curRAM = 0;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('Quantico-Regular.ttf'), 12, color);
		text = "";
		width = 600;

		peakRAM = 0;
		cacheCount = 0;
		curTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, (_) ->
		{
			__enterFrame(Lib.getTimer() - curTime);
		});
		#end
	}

	@:noCompletion @:noUsing private #if !flash override #end function __enterFrame(_d:Float):Void
	{
		this.curTime += _d;
		this.times.push(curTime);

		while (this.times[0] < this.curTime - 1000)
			this.times.shift();

		final curCount:Int = times.length;
		curFPS = Math.round((curCount + cacheCount) / 2);
		curRAM = engine.backend.util.MemoryUtil.getMemoryUsed();

		if (curRAM > peakRAM)
			peakRAM = curRAM;

		if (curCount != cacheCount)
			updateText();

		cacheCount = curCount;
	}

	@:noUsing public function updateText():Void
	{
		final _f:Bool = Save.optionsData.fpsCounter;
		final _r:Bool = Save.optionsData.ramCounter;

		final _c:String = FlxStringUtil.formatBytes(curRAM);
		final _p:String = FlxStringUtil.formatBytes(peakRAM);

		text = '${(_f ? 'FPS: ${curFPS}' : (_r ? 'RAM: ${_c} / ${_p}' : ''))}${(_f ? '\nRAM: ${_c} / ${_p}' : "")}';
	}
}
#end
