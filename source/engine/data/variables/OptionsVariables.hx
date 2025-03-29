package engine.data.variables;

@:structInit class OptionsVariables
{
	#if FEATURE_DISCORD_RPC
	/**
	 * Discord Rich Presence will showed or not?
	 */
	public var discordRPC:Bool = true;
	#end

	/**
	 * Warning menu will show in starting or no?
	 */
	public var warningVisible:Bool = true;

	/**
	 * Game FPS (Frames per Second)
	 */
	public var framerate:Int = 60;

	/**
	 * FPS Counter shows or no?
	 */
	public var fpsCounter:Bool = #if debug true #else false #end;

	/**
	 * RAM Counter shows or no?
	 */
	public var ramCounter:Bool = #if debug true #else false #end;

	/**
	 * If it's a game with flashing lights, use that so epileptics can play too!
	 */
	public var flashing:Bool = false;

	/**
	 * If it's a game with shake screen, use that so epileptics can play too!
	 */
	public var shaking:Bool = false;

	/**
	 * If it's a game with explicit contents, use for people who are 13-18 or something like that.
	 */
	public var explicit:Bool = false;

	#if FEATURE_CHECKING_UPDATE
	/**
	 * This value for checking a git-updates!
	 */
	public var updatesCheck:Bool = true;
	#end

	/**
	 * This game with anti-alias or no? (if pixel game - no)
	 */
	public var antialiasing:Bool = true;

	/**
	 * Note system offset for bluetooth users (and more)
	 */
	public var strumOffset:Float = 0;

	/**
	 * Note in screen middle
	 */
	public var middleScroll:Bool = false;

	/**
	 * Note in screen bottom
	 */
	public var scrollPos:String = "UpScroll";

	/**
	 * Screenshot export type (png or jpg)
	 */
	public var screenshotEncoder:String = "png";

	/**
	 * Caching option (RECOMMENDED FOR SUPER-DUPER-MEGA-ULTRA PC's lol :D)
	 */
	public var cacheVRAM:Bool = false;

	/**
	 * Safe frames for Note system
	 */
	public var safeFrames:Float = 10;

	/**
	 * Show's a opponent strum notes?
	 */
	public var enemyStrums:Bool = true;

	/**
	 * Shaders - are simple programs that describe the traits of either a vertex or a pixel.
	 */
	public var shaders:Bool = true;
}
