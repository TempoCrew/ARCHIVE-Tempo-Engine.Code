package tempo.ui;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

class TempoUIWindow extends FlxSpriteGroup implements ITempoUI
{
	public var name:String = "";
	public var broadcastToUI:Bool = true;
	public var overlaped:Bool = false;

	/**
	 * Change this, if window do not working.
	 */
	public var working:Bool = true;

	/**
	 * Upper sprite, where user can change a window position, viewed a window icon and text.
	 */
	public var upperSpr:Null<TempoSprite> = null;

	/**
	 * Window name text.
	 */
	public var upperSprText:Null<FlxText> = null;

	/**
	 * Window icon sprite.
	 */
	public var windowIcon(default, set):Null<TempoSprite> = null;

	/**
	 * Window sprite, where viewed all objects in current window.
	 */
	public var windowSpr:Null<TempoSprite> = null;

	/**
	 * `windowSpr` background sprite.
	 */
	public var windowBGSpr:Null<TempoSprite> = null;

	/**
	 * All objects in `this` current window.
	 */
	public var objsGrp:Null<FlxSpriteGroup> = null;

	/**
	 * Window stuff group.
	 */
	private var windowGrp:Null<FlxSpriteGroup> = null;

	public function new(x:Float, y:Float, text:String, width:Float, height:Float, ?iconSpr:TempoSprite, ?objects:Array<FlxSprite> = null):Void
	{
		super();

		windowGrp = new FlxSpriteGroup(x, y);
		add(windowGrp);

		upperSprText = new FlxText(5, 2.5, width - 10, text.toTitleCase(), 16);
		upperSprText.setFormat(TempoUIConstants.FONT, 16, TempoUIConstants.COLOR_BASE_TEXT, LEFT, OUTLINE);

		if (iconSpr != null)
		{
			this.windowIcon = iconSpr;

			upperSprText.x = (this.windowIcon.x + this.windowIcon.width) + 2.5;
		}

		reloadUpperSpr(width, upperSprText.textField.textHeight);

		windowGrp.add(upperSpr);
		windowGrp.add(upperSprText);
		if (this.windowIcon != null)
			windowGrp.add(this.windowIcon);

		reloadWindowSpr(width, height);

		objsGrp = new FlxSpriteGroup(windowSpr.x, windowSpr.y);

		windowGrp.add(windowBGSpr);
		windowGrp.add(windowSpr);
		windowGrp.add(objsGrp);

		if (objects != null)
			for (object in objects)
				objsGrp.add(object);
	}

	/**
	 * Window moving
	 */
	public var moving:Bool = false;

	/**
	 * Window focused or not
	 */
	public var focused:Bool = false;

	var mouseSelectCount:Int = 0;

	override function update(elapsed:Float):Void
	{
		final overlapedUpperSpr:Bool = TempoInput.cursorOverlaps(upperSpr, this.cameras[this.cameras.length - 1]);
		final overlapedWindowGrp:Bool = TempoInput.cursorOverlaps(windowGrp, this.cameras[this.cameras.length - 1]);
		final curMouse:FlxMouse = FlxG.mouse;

		if (working && visible)
		{
			if (overlapedWindowGrp)
			{
				if (TempoInput.cursorJustPressed)
				{
					if (broadcastToUI)
						TempoUI.focus(true, this);

					focused = true;
					reloadColors();
				}
			}
			else
			{
				if (TempoInput.cursorJustPressed)
				{
					if (broadcastToUI)
						TempoUI.focus(false, this);
					focused = false;
					reloadColors();
				}
			}

			if (overlapedUpperSpr && focused)
			{
				if (TempoInput.cursorJustPressed)
				{
					if (mouseSelectCount < 1)
					{
						TempoUI.cursor(Grabbing);

						mouseSelectCount++;
					}

					moving = true;
				}
			}

			if (focused && moving)
			{
				windowGrp.setPosition(windowGrp.x + curMouse.deltaX, windowGrp.y + curMouse.deltaY);
				if (broadcastToUI)
					TempoUI.event(TempoUIEvents.UI_WINDOW_POSITION_CHANGING, this);

				if (TempoInput.cursorJustReleased)
				{
					if (mouseSelectCount == 1)
					{
						TempoUI.cursor();

						mouseSelectCount = 0;
					}

					moving = false;
				}
			}
		}

		super.update(elapsed);
	}

	function reloadColors():Void
	{
		final color:FlxColor = (focused ? TempoUIConstants.COLOR_WINDOW_UPPER_SPR : TempoUIConstants.COLOR_WINDOW_UPPER_SPR_UNFOCUS);

		upperSpr.color = color;
		windowBGSpr.color = color;
	}

	function reloadUpperSpr(wh:Float, ht:Float):Void
	{
		upperSpr = new TempoSprite().makeRoundRectComplex({
			width: wh,
			height: ht + 10,
			color: TempoUIConstants.COLOR_WINDOW_UPPER_SPR,
			roundRect: {
				elTopLeft: 10,
				elTopRight: 10,
				elBottomRight: 0,
				elBottomLeft: 0
			}
		});
		upperSpr.updateHitbox();
	}

	function reloadWindowSpr(wh:Float, ht:Float):Void
	{
		windowSpr = new TempoSprite(1.5).makeRoundRectComplex({
			width: wh - 3,
			height: ht,
			color: TempoUIConstants.COLOR_BASE_BG,
			roundRect: {
				elTopLeft: 0,
				elTopRight: 0,
				elBottomRight: 10,
				elBottomLeft: 10
			}
		});
		windowSpr.y = (upperSpr != null ? upperSpr.height : 0);
		windowSpr.updateHitbox();

		windowBGSpr = new TempoSprite(0, windowSpr.y).makeRoundRectComplex({
			width: wh,
			height: ht + 1,
			color: TempoUIConstants.COLOR_WINDOW_UPPER_SPR,
			roundRect: {
				elTopLeft: 0,
				elTopRight: 0,
				elBottomLeft: 10,
				elBottomRight: 10
			}
		});
		windowBGSpr.updateHitbox();
	}

	function set_windowIcon(spr:TempoSprite):TempoSprite
	{
		final WD:Float = (upperSprText != null ? upperSprText.textField.textHeight : 0) + 2.5;

		spr.setGraphicSize(WD, WD);
		spr.updateHitbox();
		spr.setPosition(5, 2.5);

		windowIcon = spr;
		return spr;
	}
}
