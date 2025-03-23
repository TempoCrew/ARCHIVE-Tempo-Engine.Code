package engine.ui;

import tempo.graphic.TSG;
import engine.backend.util.SpriteUtil;
import engine.ui.debug.*;
import funkin.objects.MenuList;
import engine.backend.shaders.WhiteOverlay;
import flixel.tweens.misc.NumTween;
import flixel.util.FlxGradient;

class EditorSelectorSubState extends MusicBeatSubState
{
	static final LIST:Array<String> = [
		"Chart Editor",
		"Animation Editor",
		"Stage Editor",
		"Level Editor",
		"Character Editor",
		"Audio Editor",
		"Note Editor"
	];
	static var curSelected:Int = 0;

	var tile:FlxBackdrop;
	var letterGrp:MenuTypedList<MenuListItem>;
	var camHUD:FlxCamera;
	var boxGrp:FlxTypedSpriteGroup<TSG>;
	var boxStuffGrp:FlxSpriteGroup;
	var camObject:FlxObject;

	override function create():Void
	{
		DiscordClient.instance.changePresence({details: "Master Editor Selector"});

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		this.camera = camHUD;

		camObject = new FlxObject(0, 0, 1, 1);
		add(camObject);

		camHUD.follow(camObject, null, 0.15);

		FlxG.state.persistentUpdate = false;

		tile = new FlxBackdrop(getIcon('icon-1'), XY, 25, 25);
		tile.scale.set(0.6, 0.6);
		tile.alpha = .001;
		tile.velocity.set(15, 15);
		tile.scrollFactor.set(0.1, 0.1);
		tile.zIndex = 0;
		add(tile);

		var grad:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.BLACK, FlxColor.TRANSPARENT], 2, 0, true);
		grad.antialiasing = Save.optionsData.antialiasing;
		grad.alpha = .001;
		grad.zIndex = 1;
		grad.scrollFactor.set();
		FlxTween.tween(grad, {alpha: 0.95}, 0.4, {ease: FlxEase.quartOut});
		add(grad);

		var grad2:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.TRANSPARENT, FlxColor.BLACK], 2, 0, true);
		grad2.antialiasing = Save.optionsData.antialiasing;
		grad2.alpha = .001;
		grad2.zIndex = 1;
		grad2.scrollFactor.set();
		FlxTween.tween(grad2, {alpha: 0.95}, 0.4, {ease: FlxEase.quartOut});
		add(grad2);

		boxGrp = new FlxTypedSpriteGroup<TSG>();
		boxGrp.alpha = .001;
		FlxTween.tween(boxGrp, {alpha: 1}, 0.4, {ease: FlxEase.quartOut});
		add(boxGrp);

		boxStuffGrp = new FlxSpriteGroup();
		boxStuffGrp.alpha = .001;
		FlxTween.tween(boxStuffGrp, {alpha: 1}, 0.4, {ease: FlxEase.quartOut});
		add(boxStuffGrp);

		for (i in 0...LIST.length)
		{
			var box:TSG = new TSG(0, 400 + (i * 112), "master/box");
			box.screenCenter(X);
			box.alpha = .6;
			box.zIndex = i;
			boxGrp.add(box);

			var boxStuff:FlxSpriteGroup = new FlxSpriteGroup();
			boxStuff.alpha = .6;
			boxStuff.zIndex = i;
			boxStuffGrp.add(boxStuff);

			var text:FlxText = new FlxText(0, box.y + 25, box.width - 20, LIST[i], 32);
			text.setFormat(Paths.font('phantomMuff_Bold.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.TRANSPARENT);
			text.screenCenter(X);
			boxStuff.add(text);
		}

		changeSelection(0, false);

		super.create();
	}

	var sprY:Float = 0;
	var holdTime:Float = 0;
	var selected:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (!selected)
		{
			if (player1.controls.BACK)
			{
				Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu', null, false)));
				exit();
			}

			if (player1.controls.ACCEPT)
			{
				selected = true;
				accept();
			}

			var shiftMult:Int = 1;
			if (TempoInput.keyPressed.SHIFT)
				shiftMult = 3;

			if (player1.controls.UI_DOWN_P)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}
			if (player1.controls.UI_UP_P)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}

			if (player1.controls.UI_DOWN || player1.controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold) * (player1.controls.UI_UP ? -shiftMult : shiftMult));
			}

			if (TempoInput.cursorWheelMoved)
			{
				Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu', null, false)), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
			}
		}

		super.update(elapsed);
	}

	function exit():Void
	{
		FlxTween.tween(camHUD, {alpha: 0}, 0.15, {
			ease: FlxEase.quadInOut,
			onComplete: (t:FlxTween) ->
			{
				t = null;

				FlxG.state.persistentUpdate = true;
				DiscordClient.instance.changePresence({details: "Main Menu"});
				close();
			}
		});
	}

	function accept():Void
	{
		Tempo.playSound(Paths.loader.sound(Paths.sound('confirmMenu', null, false)));

		FlxG.sound.music.fadeOut(0.92, 0, (t:FlxTween) ->
		{
			t = null;

			Tempo.stopMusic();
		});

		for (item in boxStuffGrp)
		{
			if (item.zIndex == curSelected)
			{
				if (Save.optionsData.flashing)
					FlxFlicker.flicker(item, 1, 0.06, false, false);
			}
			else
				FlxTween.tween(item, {alpha: .001}, 0.4, {ease: FlxEase.quadOut});
		}

		for (item in boxGrp)
		{
			if (item.zIndex == curSelected)
			{
				if (Save.optionsData.flashing)
					FlxFlicker.flicker(item, 1, 0.06, false, false);

				new FlxTimer().start(1, (t:FlxTimer) ->
				{
					t = null;

					var nextState:flixel.FlxState = null;
					switch (curSelected)
					{
						case 0:
							nextState = new ChartEditorState();
						case 1:
							nextState = new AnimationEditorState();
						case 2:
							nextState = new StageEditorState();
						case 3:
							nextState = new LevelEditorState();
						case 4:
							nextState = new CharacterEditorState();
						case 5:
							nextState = new AudioEditorState();
						case 6:
							nextState = new NoteEditorState();
						default: // nothing
					}

					TempoState.switchState(nextState);
				});
			}
			else
			{
				FlxTween.tween(item, {alpha: .001}, 0.4, {ease: FlxEase.quadOut});
			}
		}
	}

	var tileTween:FlxTween;

	function changeSelection(?n:Int = 0, ?s:Bool = true):Void
	{
		if (s)
			Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu', null, false)), 0.7);

		boxGrp.members[curSelected].alpha = .6;
		boxGrp.members[curSelected].graphicLoad('master/box');
		boxStuffGrp.members[curSelected].alpha = .6;

		curSelected = FlxMath.wrap(curSelected + n, 0, LIST.length - 1);

		boxGrp.members[curSelected].alpha = 1.;
		boxGrp.members[curSelected].graphicLoad('master/box_select');
		boxStuffGrp.members[curSelected].alpha = 1.;

		camObject.setPosition(boxGrp.members[curSelected].getGraphicMidpoint().x, boxGrp.members[curSelected].getGraphicMidpoint().y);

		tile.loadGraphic(getIcon('icon-${curSelected + 1}'));
		tile.alpha = .001;

		if (tileTween != null)
			tileTween.cancel();

		tileTween = FlxTween.tween(tile, {alpha: .6}, 0.4, {
			ease: FlxEase.quadOut,
			onComplete: (t:FlxTween) ->
			{
				t = null;
			}
		});
	}

	function getIcon(image:String):FlxGraphic
	{
		return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/engine/ui/${image}.${Constants.EXT_DEBUG_IMAGE}'));
	}
}
