package tempo;

import engine.backend.util.SpriteUtil;
import tempo.animation.TempoAnimationController;
import tempo.types.*;

/**
 * Group with `TempoSprite`.
 */
typedef TempoSpriteGroup = FlxTypedGroup<TempoSprite>;

/**
 * Re-optimized and more functional `FlxSprite`.
 *
 * There many functions and etc.
 */
class TempoSprite extends FlxSprite
{
	/**
	 * Graphic for drawing stuff (roundrect and etc.).
	 */
	public var flashGfx:Graphics;

	var _flashGfxSprite:Sprite;
	var _type:TempoSpriteType;

	var _gfxData:Null<TempoSpriteGFX> = null;
	var _animOffsets:Null<Array<TempoSpriteAnimOffsets>> = null;

	public function new(?x:Float = 0, ?y:Float = 0, ?type:TempoSpriteType = SOLID_COLOR):Void
	{
		super(x, y);

		this._flashGfxSprite = new Sprite();
		this._type = type;

		this.animation = new TempoAnimationController(this);
		this.flashGfx = _flashGfxSprite.graphics;
	}

	public function makeRoundRect(data:TempoSolidColor):TempoSprite
	{
		this._type = ROUND_RECT;
		this._gfxData = data.gfxData;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		final t = data.gfxData.roundRect;

		startDraw(data.color);
		flashGfx.drawRoundRect(0, 0, data.width, data.height, t.elWidth, t.elHeight);
		endDraw();

		return this;
	}

	public function makeRoundRectComplex(data:TempoSolidColor):TempoSprite
	{
		this._type = ROUND_RECT_COMPLEX;
		this._gfxData = data.gfxData;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		final t = data.gfxData.roundRect;

		startDraw(data.color);
		flashGfx.drawRoundRectComplex(0, 0, data.width, data.height, t.elTopLeft, t.elTopRight, t.elBottomLeft, t.elBottomRight);
		endDraw();

		return this;
	}

	public function makeTriangle(data:TempoSolidColor):TempoSprite
	{
		this._type = TRIANGLE;
		this._gfxData = data.gfxData;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		final t = data.gfxData.triangle;

		startDraw(data.color);
		flashGfx.drawTriangles(t.verices, t.indices, t.uvtData, (t.culling == null ? NONE : t.culling));
		endDraw();

		return this;
	}

	public function makeQuadRect(data:TempoSolidColor):TempoSprite
	{
		this._type = QUAD;
		this._gfxData = data.gfxData;

		makeGraphic(Math.floor(data.width), Math.floor(data.height), FlxColor.TRANSPARENT);

		if (flashGfx != null)
			flashGfx.clear();

		final t = data.gfxData.quad;

		startDraw(data.color);
		flashGfx.drawQuads(t.rects, t.indices, t.transforms);
		endDraw();

		return this;
	}

	public function makeImage(data:TempoImage):TempoSprite
	{
		this._type = GRAPHIC;

		final g = Paths.loader.image(data.path, #if FEATURE_MODS_ALLOWED data.library #else data.pathIsFromFile #end);
		final a = (data.animated != null ? data.animated : false);
		final fw = (data.frameWidth != null ? data.frameWidth : 0);
		final fh = (data.frameHeight != null ? data.frameHeight : 0);
		final s = (data.animations != null ? data.animations : []);

		loadGraphic(g, a, fw, fh);

		if (data.cache != null && data.cache == true)
			SpriteUtil.cacheGraphic(data.path, this.graphic);

		if (a == true)
		{
			this.frameWidth = (fw == 0 ? Math.floor(this.width) : fw);
			this.frameHeight = (fh == 0 ? Math.floor(this.height) : fh);

			if (s.length > 0)
				for (i in 0...s.length)
					this.animation.add(s[i][0], s[i][1], (s[i][2] != null ? s[i][2] : 24), (s[i][3] != null ? s[i][3] : false));
		}

		checkAntialiasing(data.antialiasing);

		if (data.color != null)
			this.color = data.color;

		if (data.width != null && data.height != null)
			this.setGraphicSize(data.width, data.height);

		return this;
	}

	public function makeSparrowAtlas(data:TempoSparrowAtlas):TempoSprite
	{
		this._type = ANIMATE;
		this._animOffsets = [];

		frames = Paths.atlas.sparrow(data.path);

		if (data.cache != null && data.cache == true)
			SpriteUtil.cacheGraphic(data.path, this.graphic);

		checkAntialiasing(data.antialiasing);

		if (data.animations != null)
		{
			for (animData in data.animations)
			{
				_animOffsets.push({
					anim: animData.name,
					offsets: (animData.offsets == null ? {x: 0, y: 0} : {x: animData.offsets.x, y: animData.offsets.y})
				});

				if (animData.indices == null || animData.indices.length < 0)
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

		if (_animOffsets != null)
			for (i in 0..._animOffsets.length)
				if (_animOffsets[i].anim == name)
					setOffset(_animOffsets[i].offsets.x, _animOffsets[i].offsets.y);
	}

	override function set_width(v:Float):Float
	{
		this.width = v;

		checkFlashGFX();

		return width;
	}

	override function set_height(v:Float):Float
	{
		this.height = v;

		checkFlashGFX();

		return height;
	}

	public function getOffset():FlxPoint
		return this.offset;

	public function setOffset(?x:Float = 0, ?y:Float = 0):FlxPoint
		return this.offset.set(x, y);

	@:default([])
	@:noUsing inline function checkFlashGFX():TempoSprite
	{
		if (this.graphic == null)
			return null;

		if (_gfxData != null)
		{
			if (flashGfx != null)
				flashGfx.clear();

			switch (_type)
			{
				case ROUND_RECT:
					startDraw(this.color);
					flashGfx.drawRoundRect(0, 0, this.width, this.height, _gfxData.roundRect.elWidth, _gfxData.roundRect.elHeight);
					endDraw();
				case ROUND_RECT_COMPLEX:
					startDraw(this.color);
					flashGfx.drawRoundRectComplex(0, 0, this.width, this.height, _gfxData.roundRect.elTopLeft, _gfxData.roundRect.elTopRight,
						_gfxData.roundRect.elBottomLeft, _gfxData.roundRect.elBottomRight);
					endDraw();
				case CIRCLE:
					startDraw(this.color);
					flashGfx.drawCircle(0, 0, _gfxData.circle.radius);
					endDraw();
				case ELLIPSE:
					startDraw(this.color);
					flashGfx.drawEllipse(0, 0, _gfxData.ellipse.width, _gfxData.ellipse.height);
					endDraw();
				case QUAD:
					startDraw(this.color);
					flashGfx.drawQuads(_gfxData.quad.rects, _gfxData.quad.indices, _gfxData.quad.transforms);
					endDraw();
				case TRIANGLE:
					startDraw(this.color);
					flashGfx.drawTriangles(_gfxData.triangle.verices, _gfxData.triangle.indices, _gfxData.triangle.uvtData,
						(_gfxData.triangle.culling == null ? openfl.display.TriangleCulling.NONE : _gfxData.triangle.culling));
					endDraw();
				default: // nothing
			}
		}

		return this;
	}

	@:default([])
	@:noUsing inline function checkAntialiasing(?v:Bool = null):Bool
	{
		if (this.graphic == null)
			return false;

		if (v == null)
			this.antialiasing = Save.optionsData.antialiasing;
		else
			this.antialiasing = v;

		return this.antialiasing;
	}

	@:default([])
	@:noUsing inline function startDraw(fillColor:FlxColor):Void
	{
		this.flashGfx.clear();
		if (fillColor != FlxColor.TRANSPARENT)
			this.flashGfx.beginFill(fillColor.to24Bit(), fillColor.alphaFloat);
	}

	@:default([])
	@:noUsing inline function endDraw():TempoSprite
	{
		this.flashGfx.endFill();
		updateSpriteGraphic();
		return this;
	}

	inline function updateSpriteGraphic():TempoSprite
	{
		this.pixels.draw(_flashGfxSprite);
		this.dirty = true;

		return this;
	}
}
