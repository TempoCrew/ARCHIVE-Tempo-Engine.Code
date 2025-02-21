package funkin.ui.system;

/**
 *  Extends the default flixel soundtray, but with some art
 *  and lil polish!
 *
 *  Gets added to the game in TempoGame.hx, right after FlxGame is new'd
 *  since it's a Sprite rather than Flixel related object
 */
class FunkinSoundTray extends flixel.system.ui.FlxSoundTray
{
	var graphicScale:Float = 0.30;
	var lerpYPos:Float = 0;
	var alphaTarget:Float = 0;

	var volumeMaxSound:String;

	public function new()
	{
		// calls super, then removes all children to add our own
		// graphics
		super();
		removeChildren();

		final bg:Bitmap = new Bitmap(FlxAssets.getBitmapData(Paths.embed("volumebox.png")));
		bg.scaleX = graphicScale;
		bg.scaleY = graphicScale;
		addChild(bg);

		y = -height;
		visible = false;

		// makes an alpha'd version of all the bars (bar_10.png)
		final backingBar:Bitmap = new Bitmap(FlxAssets.getBitmapData(Paths.embed("bars_10.png")));
		backingBar.x = 9;
		backingBar.y = 5;
		backingBar.scaleX = graphicScale;
		backingBar.scaleY = graphicScale;
		backingBar.alpha = 0.4;
		addChild(backingBar);

		// clear the bars array entirely, it was initialized
		// in the super class
		_bars = [];

		// 1...11 due to how block named the assets,
		// we are trying to get assets bars_1-10
		for (i in 1...11)
		{
			final bar:Bitmap = new Bitmap(FlxAssets.getBitmapData(Paths.embed("bars_" + i + ".png")));
			bar.x = 9;
			bar.y = 5;
			bar.scaleX = graphicScale;
			bar.scaleY = graphicScale;
			addChild(bar);
			_bars.push(bar);
		}

		y = -height;
		screenCenter();

		volumeUpSound = Paths.embed('Volup.${#if web 'mp3' #else 'ogg' #end}');
		volumeDownSound = Paths.embed('Voldown.${#if web 'mp3' #else 'ogg' #end}');
		volumeMaxSound = Paths.embed('VolMAX.${#if web "mp3" #else "ogg" #end}');

		#if sys
		Sys.println("Custom tray added!");
		#else
		trace('Custom tray added!');
		#end
	}

	override public function update(MS:Float):Void
	{
		y = MathUtil.coolLerp(y, lerpYPos, 0.1);
		alpha = MathUtil.coolLerp(alpha, alphaTarget, 0.25);

		// Animate sound tray thing
		if (_timer > 0)
		{
			_timer -= (MS / 1000);
			alphaTarget = 1;
		}
		else if (y >= -height)
		{
			lerpYPos = -height - 10;
			alphaTarget = 0;
		}

		if (y <= -height)
		{
			visible = false;
			active = false;

			#if FLX_SAVE
			if (FlxG.save.isBound)
			{
				Save.otherData.muted = FlxG.sound.muted;
				Save.otherData.volume = FlxG.sound.volume;
				Save.save(STUFF);
			}
			#end
		}
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	override public function show(up:Bool = false):Void
	{
		_timer = 1;
		lerpYPos = 10;
		visible = true;
		active = true;
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);

		if (FlxG.sound.muted)
		{
			globalVolume = 0;
		}

		if (!silent)
		{
			var sound = up ? volumeUpSound : volumeDownSound;

			if (globalVolume == 10)
				sound = volumeMaxSound;

			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		for (i in 0..._bars.length)
		{
			if (i < globalVolume)
			{
				_bars[i].visible = true;
			}
			else
			{
				_bars[i].visible = false;
			}
		}
	}
}
