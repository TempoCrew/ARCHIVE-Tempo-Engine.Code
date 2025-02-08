package engine;

/**
 * All constant value's for game.
 */
class Constants
{
	public static final SETUP_GAME = {
		width: 1280,
		height: 720,
		initialState: engine.ui.InitState,
		zoom: -1.0,
		framerate: #if web 60 #else 144 #end,
		skipSplash: #if debug true #else false #end,
		startFullScreen: false
	};

	// WEB URL'S

	/**
	 * Engine [`Github`](https://github.com/) repository URL
	 */
	public static final GITHUB_URL:String = 'https://github.com/Mr7K-X/FNF-Tempo-Engine';

	/**
	 * Engine [`Discord`](https://discord.gg/) server URL
	 */
	public static final DISCORD_SERVER_URL:String = '';

	#if FEATURE_GAMEJOLT_CLIENT
	/**
	 * Engine [`GameJolt`](https://gamejolt.com/) page URL
	 */
	public static final GAMEJOLT_URL:String = "https://marazakx.gamejolt.io/tempo";
	#end

	/**
	 * Engine `Update` download URL
	 */
	public static final UPDATING_URL:String = "https://github.com/Mr7K-X/FNF-Tempo-Engine/releases"; // NOW IS FOR GITHUB, IN FUTURE THIS CHANGED TO GAMEBANANA/GAMEJOLT

	// DURATIONS

	/**
	 * `TempoState.switchState()` transition default duration value
	 */
	public static final TRANSITION_DURATION:Float = 0.7;

	/**
	 * `SPECIAL FOR` **`CHART EDITOR`**
	 *
	 * Default chart autosave timer (in seconds)
	 */
	public static final DEFAULT_CHARTING_AUTOSAVE_DURATION:Float = 120;

	/**
	 * `SPECIAL FOR` **`ANIMATION EDITOR`**
	 *
	 * Default animating autosave timer (in seconds)
	 */
	public static final DEFAULT_ANIMATING_AUTOSAVE_DURATION:Float = 140;

	/**
	 * `SPECIAL FOR` **`PLAYER FREEPLAY EDITOR`**
	 *
	 * Default player freeplay editor autosave timer (in seconds)
	 */
	public static final DEFAULT_FREEPLAY_EDITOR_AUTOSAVE_DURATION:Float = 120;

	/**
	 * `SPECIAL FOR` **`PLAYABLE CHARACTER EDITOR`**
	 *
	 * Default playable character editor autosave timer (in seconds)
	 */
	public static final DEFAULT_PLAY_CHAR_EDITOR_AUTOSAVE_DURATION:Float = 155;

	/**
	 * `SPECIAL FOR` **`LEVEL EDITOR`**
	 *
	 * Default level editor autosave timer (in seconds)
	 */
	public static final DEFAULT_LEVEL_EDITOR_AUTOSAVE_DURATION:Float = 200;

	/**
	 * `SPECIAL FOR` **`CUSTOM MENU EDITOR`**
	 *
	 * Default custom menu editor autosave timer (in seconds)
	 */
	public static final DEFAULT_CUSTOM_MENU_EDITOR_AUTOSAVE_DURATION:Float = 120;

	/**
	 * `SPECIAL FOR` **`STAGE EDITOR`**
	 *
	 * Default stage editor autosave timer (in seconds)
	 */
	public static final DEFAULT_STAGE_EDITOR_AUTOSAVE_DURATION:Float = 100;

	// EDITORS CONSTANTS

	/**
	 * Charting default difficulty number
	 */
	public static final CHART_EDITOR_DEFAULT_DIFFICULTY:Int = 1;

	/**
	 * Charting default difficulty name
	 */
	public static final CHART_EDITOR_DEFAULT_NAME_DIFFICULTY:String = 'normal';

	// VERSIONS

	/**
	 * Chart for `Psych Engine` exporter version
	 */
	public static final CHART_PSYCH_EXPORTER_VERSION:String = "0.1.0";

	/**
	 * `Psych Engine` chart importer version
	 */
	public static final CHART_PSYCH_IMPORTER_VERSION:String = "0.1.0";

	/**
	 * Chart for `Codename Engine` exporter version
	 */
	public static final CHART_CODENAME_EXPORTER_VERSION:String = "0.1.0";

	/**
	 * `Codename Engine` chart importer version
	 */
	public static final CHART_CODENAME_IMPORTER_VERSION:String = "0.1.0";

	/**
	 * Chart for `FNF' Legacy 0.2x` exporter version
	 */
	public static final CHART_FNF_LEGACY_EXPORTER_VERSION:String = "0.1.0";

	/**
	 * `FNF Legacy` chart importer version
	 */
	public static final CHART_FNF_LEGACY_IMPORTER_VERSION:String = "0.1.0";

	/**
	 * Chart for `V-Slice` (or FNF Update Engine) exporter version
	 */
	public static final CHART_VSLICE_EXPORTER_VERSION:String = "0.1.0";

	/**
	 * `V-Slice` (or FNF Update Engine) chart importer version
	 */
	public static final CHART_VSLICE_IMPORTER_VERSION:String = "0.1.0";

	/**
	 * Crashing dialog version
	 */
	public static var CRASH_GENERATED_VERSION:String = "0.1.0-beta";

	/**
	 * Tempo `lua` scripting version
	 */
	public static final TEMPO_LUA_VERSION:String = "0.1.0";

	/**
	 * Tempo `Inputter` version
	 */
	public static final INPUT_DATA_VERSION:String = "1_0";

	// GAMEPLAY RATINGS

	/**
	 * Rating `Sick` hit score.
	 */
	public static final SICK_RATING_SCORE:Int = 350;

	/**
	 * Rating `Sick` hit name.
	 */
	public static final SICK_RATING_NAME:String = "sick";

	/**
	 * Rating `Sick` hit offset.
	 */
	public static final SICK_RATING_OFFSET:Float = .0;

	/**
	 * Rating `Good` hit score.
	 */
	public static final GOOD_RATING_SCORE:Int = 200;

	/**
	 * Rating `Good` hit name.
	 */
	public static final GOOD_RATING_NAME:String = "good";

	/**
	 * Rating `Good` hit offset.
	 */
	public static final GOOD_RATING_OFFSET:Float = .2;

	/**
	 * Rating `Bad` hit score.
	 */
	public static final BAD_RATING_SCORE:Int = 100;

	/**
	 * Rating `Bad` hit name.
	 */
	public static final BAD_RATING_NAME:String = "bad";

	/**
	 * Rating `Bad` hit offset.
	 */
	public static final BAD_RATING_OFFSET:Float = .75;

	/**
	 * Rating `Shit` hit score.
	 */
	public static final SHIT_RATING_SCORE:Int = 50;

	/**
	 * Rating `Shit` hit name.
	 */
	public static final SHIT_RATING_NAME:String = "shit";

	/**
	 * Rating `Shit` hit offset.
	 */
	public static final SHIT_RATING_OFFSET:Float = .9;

	// NOTE / STRUM OPTIONS

	/**
	 * Note scale default value
	 */
	public static final DEFAULT_NOTE_SCALE:Float = 0.7;

	/**
	 * Note width swag default value
	 */
	public static final NOTE_SWAG_WIDTH:Float = 160 * DEFAULT_NOTE_SCALE;

	/**
	 * Default Characters `sing` animations.
	 */
	public static final SING_ANIMATIONS:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	/**
	 * Default Note Skin
	 */
	public static final DEFAULT_NOTE_SKIN:String = 'Note_Assets';

	/**
	 * Default Note-Hold Skin
	 */
	public static final DEFAULT_NOTE_TAIL_SKIN:String = 'Note_Holders';

	public static final STRUM_IDLES = ['Left', 'Down', 'Up', 'Right'];

	/**
	 * All note colors
	 */
	public static final NOTE_COLORS:Int = 4;

	/**
	 * All notes numbers for player
	 */
	public static final NOTE_TOTAL_COLUMNS:Int = 4;

	/**
	 * Note-Hold add-scale
	 */
	public static final NOTE_SUSTAIN_SCALE:Float = 44.0;

	/**
	 * Note screen hiding num
	 */
	public static final NOTE_SCREEN_Y_MULT:Float = (2000 / FlxG.height); // yes, i calculated and what you want me?? )))

	/**
	 * Strum Note's Middlescroll X Position
	 */
	public static final STRUM_MIDDLESCROLL_X:Float = -278;

	/**
	 * Strum Note's X Position
	 */
	public static final STRUM_X:Float = 27;

	/**
	 * Strum Note's Downscroll Y Position
	 */
	public static final STRUM_DOWNSCROLL_Y:Float = (FlxG.height - 150);

	/**
	 * Strum Note's Y Position
	 */
	public static final STRUM_Y:Float = 25;

	/**
	 * Strum Note's Generating, in Starting, timer
	 */
	public static final STRUM_GENERATING_TIMER:Float = 0.5;

	/**
	 * Default from `Inputter` keys for Strum press
	 */
	public static final DEFAULT_ALL_KEYS:Array<String> = ['_strumleft', '_strumdown', '_strumup', '_strumright'];

	// INITIALIZE MENU CONSTANTS

	/**
	 * `InitState` bar empty color
	 */
	public static final COLOR_INITIALIZE_BAR_EMPTY:FlxColor = FlxColor.fromString('0xFF16062B');

	/**
	 * `InitState` bar fill color
	 */
	public static final COLOR_INITIALIZE_BAR_FILL:FlxColor = FlxColor.fromString('0xFF1CF3B2');

	// EDITOR CONSTANTS
	public static final COLOR_EDITOR_UPPERBOX_LIGHT:FlxColor = FlxColor.fromString('0xFF71E7C4');
	public static final COLOR_EDITOR_UPPERBOX:FlxColor = FlxColor.fromString('0xFF0B251E');
	public static final COLOR_EDITOR_LIST_BUTTON:FlxColor = FlxColor.fromString('0xFF207E65');
	public static final COLOR_EDITOR_LIST_BOX:FlxColor = FlxColor.fromString('0xff51aa91');

	// PRELOADER CONSTANTS

	/**
	 * Color for the preloader background
	 */
	public static final COLOR_PRELOADER_BG:FlxColor = FlxColor.fromString('0xFF000000');

	/**
	 * Color for the preloader progress bar
	 */
	public static final COLOR_PRELOADER_BAR:FlxColor = FlxColor.fromString('0xFF1CF3B2');

	/**
	 * Color for the preloader site lock background
	 */
	public static final COLOR_PRELOADER_LOCK_BG:FlxColor = FlxColor.fromString('0xFF1B1717');

	/**
	 * Color for the preloader site lock foreground
	 */
	public static final COLOR_PRELOADER_LOCK_FG:FlxColor = FlxColor.fromString('0xB96F10');

	/**
	 * Color for the preloader site lock text
	 */
	public static final COLOR_PRELOADER_LOCK_FONT:FlxColor = FlxColor.fromString('0xCCCCCC');

	/**
	 * Color for the preloader site lock link
	 */
	public static final COLOR_PRELOADER_LOCK_LINK:FlxColor = FlxColor.fromString('0xEEB211');

	/**
	 * Each step of the preloader has to be on screen at least this long.
	 *
	 * 0 = The preloader immediately moves to the next step when it's ready.
	 * 1 = The preloader waits for 1 second before moving to the next step.
	 *     The progress bare is automatically rescaled to match.
	 */
	public static final PRELOADER_MIN_STAGE_TIME:Float = 0.1;

	/**
	 * Preloader screen base width.
	 */
	public static final PRELOADER_BASE_WIDTH:Float = 1280;

	/**
	 * Preload bar padding.
	 */
	public static final PRELOADER_BAR_PADDING:Float = 20;

	/**
	 * Preload bar height value.
	 */
	public static final PRELOADER_BAR_HEIGHT:Int = 12;

	/**
	 * Preload ending fade time.
	 */
	public static final PRELOADER_LOGO_FADE_TIME:Float = 1;

	/**
	 * Preloader total steps for preloading. (wow)
	 */
	public static final PRELOADER_TOTAL_STEPS:Int = 11;

	/**
	 * Preloader ellipsis time value.
	 */
	public static final PRELOADER_ELLIPSIS_TIME:Float = .5;

	// MAIN CONSTANTS

	/**
	 * The title of the game, for printing purposes.
	 */
	public static final TITLE:String = "Friday Night Funkin'";

	// VERSIONS

	/**
	 * Friday Night Funkin' base version.
	 */
	public static final BASE_VERSION:String = "0.5.3";

	/**
	 * The current version number of the game.
	 * Modify this in the `Project.hxp` file.
	 */
	public static var VERSION(get, never):String;

	#if FEATURE_DEBUG_FUNCTIONS
	static function get_VERSION():String
		return 'v${Application.current.meta.get('version')} (git: ${#if !display GIT_HASH #else '' #end}${#if !display GIT_HAS_LOCAL_CHANGES #else false #end ?' MODIFIED':''})${VERSION_SUFFIX}';

	public static var GENERATED_BY(get, never):String;

	static function get_GENERATED_BY():String
		return '${TITLE} - ${VERSION}';
	#else
	static function get_VERSION():String
		return 'v${Application.current.meta.get('version')}${VERSION_SUFFIX}';
	#end

	/**
	 * Version ending suffix.
	 */
	public static final VERSION_SUFFIX:String = #if FEATURE_DEBUG_FUNCTIONS ' PROTOTYPE' #else '' #end;

	/**
	 * All haxelibs versions.
	 */
	public static final LIBRARY_VERSION:Array<String> = engine.backend.macro.HaxelibVersionsMacro.getLibraryVersions();

	#if GITHUB_BUILD
	// GIT CONSTANTS

	/**
	 * The current Git branch.
	 */
	public static final GIT_BRANCH:String = engine.backend.macro.GitCommitMacro.getGitBranch();

	/**
	 * The current Git commit hash.
	 */
	public static final GIT_HASH:String = engine.backend.macro.GitCommitMacro.getGitCommitHash();

	/**
	 * The current Git changed in local progress.
	 */
	public static final GIT_HAS_LOCAL_CHANGES:Bool = engine.backend.macro.GitCommitMacro.getGitHasLocalChanges();
	#end

	// PATHS

	/**
	 * Screenshot images generate path.
	 */
	public static final SCREENSHOT_FOLDER:String = "engine/screenshots";

	/**
	 * User data path.
	 */
	public static final USER_DATA_FILE:String = "user.dat";

	// DEFAULT CONSTANTS
	public static final DEFAULT_DISCORD_CLIENT_ID:String = "1131981056170545334";

	/**
	 * Number of steps in a beat.
	 * One step is one 16th note and one beat is one quarter note.
	 */
	public static final STEPS_PER_BEAT:Int = 4;

	/**
	 * Default transition time.
	 */
	public static final DEFAULT_TRANSITION_TIMER:Float = 0.7;

	/**
	 * Save extractor tag
	 */
	public static final SAVE_TAG:String = "tempo";

	// EXTENSIONS CONSTANTS

	/**
	 * Image file extension.
	 */
	public static final EXT_IMAGE:String = "png";

	/**
	 * Chart archive extension. (using for editor)
	 */
	public static final EXT_CHART:String = "chrt";

	/**
	 * Music meta data file extension.
	 */
	public static final EXT_METADATA:String = "meta";

	/**
	 * Song package archive extension. (using for charts in gameplay, for initialize chart data, music and meta data)
	 */
	public static final EXT_SONG_PACKAGE:String = "spa";

	/**
	 * Debug images extension.
	 */
	public static final EXT_DEBUG_IMAGE:String = "tsg";

	/**
	 * File autosave cache/binary extension.
	 */
	public static final EXT_AUTOSAVE:String = "auto";

	/**
	 * Stage file data extension.
	 */
	public static final EXT_STAGE:String = "stg";

	/**
	 * Stage object file data extension.
	 */
	public static final EXT_OBJECT:String = "obj";

	/**
	 * Playable character file data extension.
	 */
	public static final EXT_PLAYER:String = "plr";

	/**
	 * Level file data extension.
	 */
	public static final EXT_LEVEL:String = "lvl";

	/**
	 * Animation file data extension.
	 */
	public static final EXT_ANIMATION:String = "anim";

	/**
	 * Audio file extension.
	 */
	public static final EXT_SOUND:String = #if web "mp3" #else "ogg" #end;
}
