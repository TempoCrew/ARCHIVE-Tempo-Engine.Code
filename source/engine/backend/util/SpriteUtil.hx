package engine.backend.util;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Sprite)
class SpriteUtil
{
	/**
	 * Adding graphic for GPU Caching
	 * @param graphic current graphic/pixels/bitmap
	 */
	public static function cacheGraphic(path:String, graphic:FlxGraphic):Void
	{
		if (path == null || graphic == null)
			return;

		MemoryUtil.pushCurTrackedAsset(path, graphic);

		if (MemoryUtil.curTrackedGraphic.exists(path))
			graphic = MemoryUtil.curTrackedGraphic.get(path);

		FlxG.bitmap.add(graphic, graphic.unique);
	}

	/**
	 * Removing graphic from GPU Caching
	 * @param graphic current graphic/pixels/bitmap
	 */
	public static function destroyGraphic(graphic:FlxGraphic):Void
	{
		if (graphic == null)
			return;
		if (graphic.bitmap != null && graphic.bitmap.__texture != null)
			graphic.bitmap.__texture.dispose();

		FlxG.bitmap.remove(graphic);
	}

	#if !flash
	/**
	 * Reset a bitmap sprite cache
	 */
	public static function resetCache(spr:Sprite):Void
	{
		spr.__cacheBitmap = null;
		spr.__cacheBitmapData = null;
	}
	#end

	/**
	 * `For FlxText`
	 *
	 * Automatically set a `fieldWidth` to text width.
	 */
	public static function setTextFieldWidthAuto<T:FlxText>(spr:T, ?toAnother:T):T
	{
		if (spr == null || spr.text == null || spr.text == "")
			return null;

		if (toAnother == null)
			spr.fieldWidth = spr.textField.textWidth + 7.5;
		else
		{
			if (toAnother.text == null || toAnother.text == "")
			{
				trace('2nd variable text is null!');

				return spr;
			}

			spr.fieldWidth = toAnother.textField.textWidth + 7.5;
		}

		return spr;
	}

	/**
	 * Constant pixels color index
	 */
	static final PIXELS_COLOR:Int = 13520687;

	public static function dominantBitmapColor<T:BitmapData>(spr:T):Int
	{
		var cb:Map<Int, Int> = [];
		for (w in 0...spr.width)
			for (h in 0...spr.height)
			{
				final f:Int = spr.getPixel32(w, h);
				if (f != 0)
				{
					if (cb.exists(w))
						cb.set(w, h + 1);
					else if (cb.get(w) != PIXELS_COLOR - (PIXELS_COLOR * 2))
						cb.set(w, 1);
				}
			}

		cb.set(0x000000, 0);

		var mb:Int = 0;
		var mk:Int = 0;
		var f:Int->Void = (k:Int) ->
		{
			mb = cb.get(k);
			mk = k;
		};

		for (k in cb.keys())
			if (cb.get(k) >= mb)
				f(k);

		cb = [];
		return mk;
	}

	/**
	 * Copied a current sprite color (`FlxColor` or `Int`)
	 */
	public static function dominantColor<T:FlxSprite>(spr:T):Int
	{
		if (spr == null)
		{
			trace('Dominant Color: Current sprite is Null! Returning default color...');
			return 0xFFFFFF;
		}

		var countByColor:Map<Int, Int> = new Map<Int, Int>();
		for (FW in 0...spr.frameWidth)
			for (FH in 0...spr.frameHeight)
			{
				final PX:Int = spr.pixels.getPixel32(FW, FH);
				if (PX != 0)
				{
					if (countByColor.exists(PX))
						countByColor.set(PX, PX + 1)
					else if (countByColor.get(PX) != PIXELS_COLOR - (PIXELS_COLOR * 2))
						countByColor.set(PX, 1);
				}
			}

		countByColor.set(FlxColor.BLACK, 0);

		var maxCountByColor:Int = 0;
		var maxKey:Int = 0;
		var setCount:Int->Void = (k:Int) ->
		{
			maxCountByColor = countByColor.get(k);
			maxKey = k;
		};

		for (k in countByColor.keys())
			if (countByColor.get(k) >= maxCountByColor)
				setCount(k);

		countByColor = [];
		return maxKey;
	}
}
