package engine.backend.util;

#if FEATURE_SMOOTH_UNFOCUS_MUSIC
import flixel.tweens.misc.NumTween;
#end
import engine.types.VolUpdateData;

@:access(openfl.media.Sound)
@:access(lime.media.AudioSource)
class SoundUtil
{
	#if FEATURE_SMOOTH_UNFOCUS_MUSIC
	static var volTween:NumTween = null;

	public static function initUnFocusVol():Void
	{
		WindowsUtil.windowUnFocus.add(() ->
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				final leVol:Float = (volTween != null ? volTween.value : FlxG.sound.music.volume);
				if (volTween != null)
					volTween.cancel();

				volTween = FlxTween.num(leVol, Constants.UNFOCUS_MUSIC_VOL, Constants.UNFOCUS_MUSIC_TIME, {
					ease: FlxEase.quadIn,
					onComplete: (tween:FlxTween) ->
					{
						tween = null;
					}
				}, (num:Float) ->
					{
						FlxG.sound.music.volume = num;
					});
			}
		});
		WindowsUtil.windowFocus.add(() ->
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				final leVol:Float = (volTween != null ? volTween.value : 1.);
				if (volTween != null)
					volTween.cancel();

				volTween = FlxTween.num(leVol, FlxG.sound.music.getActualVolume(), Constants.FOCUS_MUSIC_TIME, {
					ease: FlxEase.quadOut,
					onComplete: (tween:FlxTween) ->
					{
						tween = null;
					}
				}, (num:Float) ->
					{
						FlxG.sound.music.volume = num;
					});
			}
		});
	}
	#end

	public static function updateVolume<T:FlxSound>(data:VolUpdateData<T>)
	{
		if (data.sound != null)
			if (data.sound.volume < data.toVolume)
				data.sound.volume += data.addVolume * data.elapsed;
	}

	public static function loadFlxSound(path:String, volume:Float = 1., ?loop:Bool = false):FlxSound
	{
		var snd:FlxSound = new FlxSound();
		snd.loadEmbedded(Paths.loader.sound(path), loop);
		snd.volume = volume;

		return snd;
	}

	public static function destroySound(sound:Sound):Void
	{
		if (sound == null)
			return;

		if (sound.__buffer != null)
			sound.__buffer.dispose();

		sound.close();
	}

	public static function disposeSound(sound:Sound):Sound
	{
		if (sound == null || sound.__buffer == null)
			return null;

		sound.__pendingAudioSource.buffer.dispose();
		sound.__pendingAudioSource.dispose();
		sound.__pendingAudioSource.buffer.data = null;
		sound.__pendingAudioSource.buffer = null;

		return sound;
	}
}
