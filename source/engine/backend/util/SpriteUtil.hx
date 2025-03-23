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

		MemoryUtil.pushCurTrackedGraphic(path, graphic);

		if (MemoryUtil.curTrackedGraphic.exists(path))
			graphic = MemoryUtil.curTrackedGraphic.get(path);

		FlxG.bitmap.add(graphic, graphic.unique, graphic.key);
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

	@:access(openfl.display.BitmapData)
	public static function disposeBitmap(bitmap:BitmapData):BitmapData
	{
		if (bitmap == null || bitmap.image == null)
		{
			trace('Could not dispose this bitmap, because data is null!');
			return null;
		}

		bitmap.lock();
		if (bitmap.__texture == null)
		{
			bitmap.image.premultiplied = true;
			bitmap.getTexture(Lib.current.stage.context3D);
		}
		bitmap.getSurface();
		bitmap.disposeImage();
		bitmap.image.data = null;
		bitmap.image = null;
		bitmap.readable = true;

		return bitmap;
	}

	/**
	 * I'mma lazy
	 * @param graphic
	 * @param invertX
	 * @param invertY
	 * @param roundRectSize
	 */
	public static function drawRoundRectBitmap(graphic:BitmapData, invertX:Bool, invertY:Bool, ?roundRectSize:Int = 11, ?cornerColor:Int = 0x0):Void
	{
		var antiPoint:FlxPoint = FlxPoint.get((graphic.width - roundRectSize), invertY ? (graphic.height - 1) : 0);

		if (invertY)
			antiPoint.y -= 2;

		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 1), Math.floor(Math.abs(antiPoint.y - 8)), 10, 3), cornerColor);

		if (invertY)
			antiPoint.y += 1;

		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 2), Math.floor(Math.abs(antiPoint.y - 6)), 9, 2), cornerColor);

		if (invertY)
			antiPoint.y += 1;

		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 3), Math.floor(Math.abs(antiPoint.y - 5)), 8, 1), cornerColor);
		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 4), Math.floor(Math.abs(antiPoint.y - 4)), 7, 1), cornerColor);
		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 5), Math.floor(Math.abs(antiPoint.y - 3)), 6, 1), cornerColor);
		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 6), Math.floor(Math.abs(antiPoint.y - 2)), 5, 1), cornerColor);
		graphic.fillRect(new Rectangle((invertX ? antiPoint.x : 8), Math.floor(Math.abs(antiPoint.y - 1)), 3, 1), cornerColor);
	}

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
					else if (cb.get(w) != Constants.PIXELS_COLOR - (Constants.PIXELS_COLOR * 2))
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
					else if (countByColor.get(PX) != Constants.PIXELS_COLOR - (Constants.PIXELS_COLOR * 2))
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
