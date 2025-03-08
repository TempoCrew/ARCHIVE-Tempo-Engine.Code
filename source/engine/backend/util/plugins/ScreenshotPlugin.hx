package engine.backend.util.plugins;

import engine.input.Cursor;
import flixel.util.FlxSignal.FlxTypedSignal;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

typedef ScreenshotPluginParams =
{
	var ?region:Rectangle;
	var shouldHideMouse:Bool;
	var flashColor:Null<FlxColor>;
	var fancyPreview:Bool;
}

/**
 * Plugin for screenshot screen.
 *
 * For fun
 */
@:access(engine.input.Controls)
class ScreenshotPlugin extends FlxBasic
{
	// STATIC VARIABLES, FUNCTIONS AND ETC.
	public static final DEFAULT_SCREENSHOT_PARAMS:ScreenshotPluginParams = {
		flashColor: FlxColor.WHITE,
		shouldHideMouse: false,
		fancyPreview: true
	};

	public static function initialize():Void
		FlxG.plugins.addPlugin(new ScreenshotPlugin(DEFAULT_SCREENSHOT_PARAMS));

	public static final PREVIEW_INITIAL_DELAY:Float = .25;
	public static final PREVIEW_FADE_IN_DURATION:Float = .3;
	public static final PREVIEW_FADE_OUT_DELAY:Float = 1.25;
	public static final PREVIEW_FADE_OUT_DURATION:Float = .3;

	// DONT TOUCH THIS ASS (LMAO)
	@:private var _region:Null<Rectangle> = null;
	@:private var _shouldHideMouse:Null<Bool> = null;
	@:private var _flashColor:Null<FlxColor> = null;
	@:private var _fancyPreview:Null<Bool> = null;

	// TOUCH THIS IF YOU CAN (LOL)
	public var onPreScreenshot(default, null):FlxTypedSignal<Void->Void>;
	public var onPostScreenshot(default, null):FlxTypedSignal<Bitmap->Void>;

	public function new(params:ScreenshotPluginParams):Void
	{
		super();

		_region = params?.region ?? null;
		_shouldHideMouse = params.shouldHideMouse;
		_flashColor = params.flashColor;
		_fancyPreview = params.fancyPreview;

		onPreScreenshot = new FlxTypedSignal<Void->Void>();
		onPostScreenshot = new FlxTypedSignal<Bitmap->Void>();
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (engine.input.Controls.instance._justPress('_screenshot'))
			capture();
	}

	public function capture():Void
	{
		onPreScreenshot.dispatch();

		var wasMouseHidden:Bool = false;
		if (_shouldHideMouse && TempoInput.cursor.visible)
		{
			wasMouseHidden = true;
			Cursor.hide();
		}

		final bitmap:Bitmap = new Bitmap(BitmapData.fromImage(Lib.current.stage.window.readPixels()));
		if (wasMouseHidden)
			Cursor.show();

		saveFile(bitmap);

		if (Save.optionsData.flashing)
			showCaptureFeedback();
		if (_fancyPreview)
			showFancyPreview(bitmap);

		onPostScreenshot.dispatch(bitmap);
	}

	static function saveFile(bitmap:Bitmap):Void
	{
		initPath();
		final targetPath:String = getPath();
		final pngData:ByteArray = encode(bitmap);

		if (pngData == null)
		{
			trace('[WARNING] Failed to encode PNG data. Returning...');
			return;
		}
		else
		{
			trace('File saved to: $targetPath');
			FileUtil.writeBytesToPath(targetPath, pngData);
		}
	}

	static function encode(bitmap:Bitmap):ByteArray
	{
		return bitmap.bitmapData.encode(bitmap.bitmapData.rect,
			(Save.optionsData.screenshotEncoder == 'png' ? new openfl.display.PNGEncoderOptions() : new openfl.display.JPEGEncoderOptions(100)));
	}

	static function initPath():Void
	{
		FileUtil.createFolderIfNotExist(Constants.SCREENSHOT_FOLDER);
	}

	static function getPath():String
		return '${Constants.SCREENSHOT_FOLDER}/tempo-${DateUtil.generateTimestamp()}.${Constants.EXT_IMAGE}';

	final FLASH_DURATION:Float = .15;

	function showCaptureFeedback():Void
	{
		var flashBitmap:Bitmap = new Bitmap(new BitmapData(Constants.SETUP_GAME.width, Constants.SETUP_GAME.height, false, _flashColor));
		var flashSpr:Sprite = new Sprite();
		flashSpr.addChild(flashBitmap);
		Lib.current.addChild(flashSpr);
		FlxTween.tween(flashSpr, {alpha: 0}, FLASH_DURATION, {
			ease: FlxEase.quadOut,
			onComplete: (t:FlxTween) ->
			{
				t = null;
				Lib.current.addChild(flashSpr);
			}
		});

		FlxG.sound.play(flixel.system.FlxAssets.getSound(Paths.embed('screenshot.${Constants.EXT_SOUND}')));
	}

	function openScreenshotsFolder(e:MouseEvent):Void
	{
		FileUtil.openFolder(Constants.SCREENSHOT_FOLDER);
	}

	function onHover(e:MouseEvent):Void
	{
		if (!changingAlpha)
			e.target.alpha = 0.6;
	}

	function onHoverOut(e:MouseEvent):Void
	{
		if (!changingAlpha)
			e.target.alpha = 1;
	}

	var changingAlpha:Bool = false;

	function showFancyPreview(bitmap:Bitmap):Void
	{
		// ermmm stealing this??
		var wasMouseHidden = false;
		if (!TempoInput.cursor.visible)
		{
			wasMouseHidden = true;
			Cursor.show();
		}

		// so that it doesnt change the alpha when tweening in/out
		changingAlpha = false;
		// fuck it, cursed locally scoped functions, purely because im lazy
		// (and so we can check changingAlpha, which is locally scoped.... because I'm lazy...)
		final scale:Float = .25;
		final w:Int = Std.int(bitmap.bitmapData.width * scale);
		final h:Int = Std.int(bitmap.bitmapData.height * scale);

		var preview:BitmapData = new BitmapData(w, h, true);
		var matrix:openfl.geom.Matrix = new openfl.geom.Matrix();

		matrix.scale(scale, scale);
		preview.draw(bitmap.bitmapData, matrix);

		// used for movement + button stuff
		var previewSprite = new Sprite();
		previewSprite.buttonMode = true;
		previewSprite.addEventListener(MouseEvent.MOUSE_DOWN, openScreenshotsFolder);
		previewSprite.addEventListener(MouseEvent.MOUSE_OVER, onHover);
		previewSprite.addEventListener(MouseEvent.MOUSE_OUT, onHoverOut);
		Lib.current.addChild(previewSprite);

		previewSprite.alpha = 0.0;
		previewSprite.y -= 10;

		var previewBitmap = new Bitmap(preview);
		previewSprite.addChild(previewBitmap);

		new FlxTimer().start(PREVIEW_INITIAL_DELAY, (t:FlxTimer) ->
		{
			t = null;

			// Fade in.
			changingAlpha = true;
			FlxTween.tween(previewSprite, {alpha: 1.0, y: 0}, PREVIEW_FADE_IN_DURATION, {
				ease: FlxEase.quartOut,
				onComplete: (t:FlxTween) ->
				{
					t = null;
					changingAlpha = false;

					// Wait to fade out.
					new FlxTimer().start(PREVIEW_FADE_OUT_DELAY, (t:FlxTimer) ->
					{
						t = null;
						changingAlpha = true;

						// Fade out.
						FlxTween.tween(previewSprite, {alpha: 0.0, y: 10}, PREVIEW_FADE_OUT_DURATION, {
							ease: FlxEase.quartInOut,
							onComplete: (t:FlxTween) ->
							{
								t = null;
								// if (wasMouseHidden) CoolStuff.cursor(null, false);

								previewSprite.removeEventListener(MouseEvent.MOUSE_DOWN, openScreenshotsFolder);
								previewSprite.removeEventListener(MouseEvent.MOUSE_OVER, onHover);
								previewSprite.removeEventListener(MouseEvent.MOUSE_OUT, onHoverOut);
								Lib.current.removeChild(previewSprite);
							}
						});
					});
				}
			});
		});
	}
}
