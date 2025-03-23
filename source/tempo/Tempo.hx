package tempo;

class Tempo
{
	/**
	 * Paused a `FlxG.sound.music`.
	 */
	public static function pauseMusic():FlxSound
		return pauseSound(FlxG.sound.music);

	/**
	 * Stop a `FlxG.sound.music`.
	 */
	public static function stopMusic():FlxSound
		return stopSound(FlxG.sound.music);

	/**
	 * Resume a `FlxG.sound.music`.
	 */
	public static function resumeMusic():FlxSound
		return resumeSound(FlxG.sound.music);

	/**
	 * Play a `FlxG.sound.music`.
	 *
	 * @param id Where this file exists? Use `Paths.loader.sound()` for this.
	 * @param volume Starting music volume.
	 * @param loop This music will not ended?
	 *
	 * @return `FlxG.sound.music`
	 */
	public static function playMusic(id:FlxSoundAsset, ?volume:Float = 1.0, ?loop:Bool = true):FlxSound
	{
		if (id == null)
		{
			trace('Not loaded a music! ($id)');
			return null;
		}

		FlxG.sound.playMusic(id, volume, loop);
		return FlxG.sound.music;
	}

	/**
	 * Pause a `id` sound.
	 * @param id Variable extends a `FlxSound` (example: `FlxG.sound.music`).
	 */
	public static function pauseSound(id:FlxSound):FlxSound
	{
		if (id != null && id.playing)
			return id.pause();

		return null;
	}

	/**
	 * Resume a `id` sound.
	 * @param id Variable extends a `FlxSound` (example: `FlxG.sound.music`).
	 */
	public static function resumeSound(id:FlxSound):FlxSound
	{
		if (id != null && !id.playing)
			return id.resume();

		return null;
	}

	/**
	 * Stop a `id` sound.
	 * @param id Variable extends a `FlxSound` (example: `FlxG.sound.music`).
	 */
	public static function stopSound(id:FlxSound):FlxSound
	{
		if (id != null)
			return id.stop();

		return null;
	}

	/**
	 * Play a sound in Game System.
	 * @param id Where this file exists? Use `Paths.loader.sound()` for this.
	 * @param volume Starting music volume.
	 * @param loop This music will not ended?
	 */
	public static function playSound(id:FlxSoundAsset, ?volume:Float = 1.0, ?loop:Bool = false):Void
	{
		if (id == null)
		{
			trace('Not loaded a sound! ($id)');
			return;
		}

		FlxG.sound.play(id, volume, loop);
	}
}
