package tempo.graphic;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

/**
 * `Tempo Sprite Graphic` or for short `TSG`.
 *
 * It's used for debug stuff and editor images.
 */
class TSG extends TempoSprite
{
	public function new(x:Float = 0, y:Float = 0, ?image:String):Void
	{
		super(x, y, GRAPHIC);

		if (image != null)
			graphicLoad(image);

		checkAntialiasing();
	}

	public function graphicLoad(image:String, ?isAnim:Bool = false, ?animW:Int = 0, ?animH:Int = 0):TSG
	{
		this.loadGraphic(FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/engine/ui/$image.${Constants.EXT_DEBUG_IMAGE}')), isAnim, animW, animH);
		return this;
	}
}
