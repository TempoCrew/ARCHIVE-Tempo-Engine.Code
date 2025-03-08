package engine.backend.util;

import engine.types.VolUpdateData;

class SoundUtil
{
	public static function updateVolume<T:FlxSound>(data:VolUpdateData<T>)
	{
		if (data.sound != null)
			if (data.sound.volume < data.toVolume)
				data.sound.volume += data.addVolume * data.elapsed;
	}
}
