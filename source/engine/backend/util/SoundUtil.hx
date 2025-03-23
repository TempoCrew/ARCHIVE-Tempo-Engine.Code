package engine.backend.util;

import openfl.geom.Point;
import engine.types.VolUpdateData;

@:access(openfl.media.Sound)
@:access(lime.media.AudioSource)
class SoundUtil
{
	public static function updateVolume<T:FlxSound>(data:VolUpdateData<T>)
	{
		if (data.sound != null)
			if (data.sound.volume < data.toVolume)
				data.sound.volume += data.addVolume * data.elapsed;
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
