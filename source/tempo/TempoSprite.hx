package tempo;

import engine.backend.util.SpriteUtil;
import openfl.display.Graphics;
import tempo.animation.TempoAnimationController;
import tempo.types.*;

typedef TempoSpriteGroup = FlxTypedGroup<TempoSprite>;

class TempoSprite extends FlxSprite
{
	public var flashGfx:Graphics;

	var _flashGfxSprite:Sprite;
	var type:TempoSpriteType;

	var roundRect:Null<TempoRoundRect> = null;
	var animOffsets:Null<Array<TempoSpriteAnimOffsets>> = null;

	public function new(?x:Float = 0, ?y:Float = 0, ?type:TempoSpriteType = SOLID_COLOR):Void
	{
		super(x, y);

		this.type = type;
		this._flashGfxSprite = new Sprite();
		this.flashGfx = _flashGfxSprite.graphics;
		this.animation = new TempoAnimationController(this);
	}

	public function makeRoundRect(data:TempoSolidColor):TempoSprite
	{
		this.type = ROUND_RECT;
		this.roundRect = data.roundRect;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		startDraw(data.color);
		flashGfx.drawRoundRect(0, 0, data.width, data.height, data.roundRect.elWidth, data.roundRect.elHeight);
		endDraw();

		return this;
	}

	public function makeRoundRectComplex(data:TempoSolidColor):TempoSprite
	{
		this.type = ROUND_RECT_COMPLEX;
		this.roundRect = data.roundRect;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		startDraw(data.color);
		flashGfx.drawRoundRectComplex(0, 0, data.width, data.height, data.roundRect.elTopLeft, data.roundRect.elTopRight, data.roundRect.elBottomLeft,
			data.roundRect.elBottomRight);
		endDraw();

		return this;
	}

	public function makeImage(data:TempoImage):TempoSprite
	{
		this.type = GRAPHIC;

		trace(data.path);

		loadGraphic(BitmapData.fromFile('${data.path}.png'), (data.animated != null ? data.animated : false), (data.frameWidth != null ? data.frameWidth : 0),
			(data.frameHeight != null ? data.frameHeight : 0));

		if (data.cache != null && data.cache == true)
			SpriteUtil.cacheGraphic(data.path, this.graphic);

		if (data.animated != null && data.animated == true)
		{
			this.frameWidth = (data.frameWidth != null ? data.frameWidth : Math.floor(this.width));
			this.frameHeight = (data.frameHeight != null ? data.frameHeight : Math.floor(this.height));

			for (i in 0...data.animations.length)
				this.animation.add(data.animations[i][0], data.animations[i][1], (data.animations[i][2] != null ? data.animations[i][2] : 24),
					(data.animations[i][3] != null ? data.animations[i][3] : false));
		}

		if (data.color != null)
			this.color = data.color;

		if (data.width != null && data.height != null)
			this.setGraphicSize(data.width, data.height);

		return this;
	}

	public function makeSparrowAtlas(data:TempoSparrowAtlas):TempoSprite
	{
		this.type = ANIMATE;
		this.animOffsets = [];

		frames = Paths.loader.atlas.sparrow(data.path);

		if (data.cache != null && data.cache == true)
			SpriteUtil.cacheGraphic(data.path, this.graphic);

		if (data.animations != null)
		{
			for (animData in data.animations)
			{
				animOffsets.push({
					anim: animData.name,
					offsets: (animData.offsets == null ? {x: 0, y: 0} : {x: animData.offsets.x, y: animData.offsets.y})
				});

				if (animData.indices == null)
				{
					this.animation.addByPrefix(animData.name, animData.prefix, (animData.framerate != null ? animData.framerate : 24),
						(animData.looped != null ? animData.looped : false));
				}
				else
				{
					this.animation.addByIndices(animData.name, animData.prefix, animData.indices, (animData.postfix == null ? "" : animData.postfix),
						(animData.framerate != null ? animData.framerate : 24), (animData.looped != null ? animData.looped : false));
				}
			}
		}

		return this;
	}

	public function playAnim(name:String, ?force:Bool = false, ?reversed:Bool = false, ?frame:Int = 0):Void
	{
		if (this.animation.exists(name))
			this.animation.play(name, force, reversed, frame);
		else
			trace("playAnim: '" + name + "' animation not exists!");

		if (this.animOffsets != null)
			for (i in 0...this.animOffsets.length)
				if (this.animOffsets[i].anim == name)
					setOffset(this.animOffsets[i].offsets.x, this.animOffsets[i].offsets.y);
	}

	override function set_width(v:Float):Float
	{
		width = v;

		if (this.roundRect != null)
		{
			if (this.type == ROUND_RECT)
			{
				this.startDraw(this.color);
				this.flashGfx.drawRoundRect(0, 0, v, this.height, this.roundRect.elWidth, this.roundRect.elHeight);
				this.endDraw();
			}
			else if (this.type == ROUND_RECT_COMPLEX)
			{
				this.startDraw(this.color);
				this.flashGfx.drawRoundRectComplex(0, 0, v, this.height, this.roundRect.elTopLeft, this.roundRect.elTopRight, this.roundRect.elBottomLeft,
					this.roundRect.elBottomRight);
				this.endDraw();
			}
		}

		return width;
	}

	override function set_height(v:Float):Float
	{
		height = v;

		if (this.roundRect != null)
		{
			if (this.type == ROUND_RECT)
			{
				this.startDraw(this.color);
				this.flashGfx.drawRoundRect(0, 0, this.width, v, this.roundRect.elWidth, this.roundRect.elHeight);
				this.endDraw();
			}
			else if (this.type == ROUND_RECT_COMPLEX)
			{
				this.startDraw(this.color);
				this.flashGfx.drawRoundRectComplex(0, 0, this.width, v, this.roundRect.elTopLeft, this.roundRect.elTopRight, this.roundRect.elBottomLeft,
					this.roundRect.elBottomRight);
				this.endDraw();
			}
		}

		return height;
	}

	public function getOffset():FlxPoint
		return this.offset;

	public function setOffset(?x:Float = 0, ?y:Float = 0):FlxPoint
		return this.offset.set(x, y);

	@:noUsing public inline function startDraw(fillColor:FlxColor):Void
	{
		this.flashGfx.clear();
		if (fillColor != FlxColor.TRANSPARENT)
			this.flashGfx.beginFill(fillColor.to24Bit(), fillColor.alphaFloat);
	}

	@:noUsing public inline function endDraw():TempoSprite
	{
		this.flashGfx.endFill();
		updateSpriteGraphic();
		return this;
	}

	private function updateSpriteGraphic():TempoSprite
	{
		this.pixels.draw(_flashGfxSprite);
		this.dirty = true;

		return this;
	}
}
