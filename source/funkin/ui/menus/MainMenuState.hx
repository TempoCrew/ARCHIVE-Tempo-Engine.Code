package funkin.ui.menus;

import engine.backend.util.SoundUtil;
import engine.backend.util.MemoryUtil;

class MainMenuState extends MusicBeatState
{
	public static var instance:MainMenuState;

	static var curSelected:Int = 0;

	final ITEMS:Array<String> = ["storymode", "freeplay", "credits", "options"];

	var menuGrp:TempoSpriteGroup;
	var camObject:FlxObject;

	override function create():Void
	{
		MemoryUtil.removeUnusedMemory();
		MemoryUtil.removeStoredMemory();

		DiscordClient.instance.changePresence({details: "Main Menu"});

		instance = this;

		if (!FlxG.sound.music.playing || FlxG.sound.music == null)
			Tempo.playMusic(Paths.loader.sound(Paths.music('freakyMenu', null, false)), 0.0, true);

		var bg:TempoSprite = new TempoSprite(-1, -1, GRAPHIC);
		bg.makeImage({path: Paths.image('menuBG', null, false)});
		bg.scrollFactor.set(0, (ITEMS.length > 4 ? .25 : .15));
		bg.setGraphicSize(bg.width * 1.175);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		menuGrp = new TempoSpriteGroup();
		add(menuGrp);

		for (i in 0...ITEMS.length)
		{
			final path:String = ITEMS[i];
			var item:TempoSprite = new TempoSprite(0, (i * 149), ANIMATE);
			item.zIndex = i;
			item.makeSparrowAtlas({
				path: Paths.image('mainmenu/$path'),
				animations: [
					{
						name: "idle",
						prefix: '$path idle',
						framerate: 24,
						looped: true
					},
					{
						name: "selected",
						prefix: '$path selected',
						framerate: 24,
						looped: true
					}
				]
			});
			item.playAnim('idle');
			item.scrollFactor.set(1, (ITEMS.length > 4 ? 1 : 0.7));
			item.centerOffsets();
			item.updateHitbox();
			item.screenCenter(X);
			item.y += 100;
			menuGrp.add(item);
		}

		addBottomText(FlxG.height - 44, 'Tempo Engine ${Constants.VERSION}');
		addBottomText(FlxG.height - 24, 'Friday Night Funkin\' v${Constants.BASE_VERSION}');

		camObject = new FlxObject(0, 0, 1, 1);
		add(camObject);

		FlxG.camera.follow(camObject, null, .4);

		changeSelection(0, false);

		super.create();
	}

	var uiSelected:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float):Void
	{
		if (!uiSelected)
		{
			SoundUtil.updateVolume({
				sound: FlxG.sound.music,
				toVolume: 0.7,
				addVolume: .5,
				elapsed: elapsed
			});

			var shiftMult:Int = 1;
			if (TempoInput.keyPressed.SHIFT)
				shiftMult = 3;

			if (player1.controls.BACK)
			{
				uiSelected = true;
				Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu', null, false)));
				TempoState.switchState(new TitleState());
			}
			else if (player1.controls.ACCEPT)
			{
				uiSelected = true;
				Tempo.playSound(Paths.loader.sound(Paths.sound('confirmMenu', null, false)));
				select();
			}

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

			if (TempoInput.keyJustPressed.TAB)
			{
				openSubState(new engine.ui.EditorSelectorSubState());
				Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu.${Constants.EXT_SOUND}')));
			}
		}

		super.update(elapsed);
	}

	function select():Void
	{
		menuGrp.forEach((spr:TempoSprite) ->
		{
			if (spr.zIndex == curSelected)
			{
				FlxFlicker.flicker(spr, 1, 0.06, false, false);

				if (ITEMS[curSelected] == 'freeplay')
					FlxG.sound.music.fadeOut(0.8, 0, (_) ->
					{
						Tempo.stopMusic();
					});

				new FlxTimer().start(1, (_) ->
				{
					var nextState:flixel.FlxState = null;
					var nextSubState:flixel.FlxSubState = null;
					var name:String = ITEMS[curSelected];

					switch (name)
					{
						case 'storymode':
							nextState = new StoryMenuState();
						case 'freeplay':
							nextSubState = new FreeplaySubState();
						case 'credits':
							nextState = new CreditsState();
						case 'options':
							nextState = new OptionsState();
					}

					if (nextState != null && nextSubState == null)
						TempoState.switchState(nextState);
					else if (nextState == null && nextSubState != null)
						FlxG.state.openSubState(nextSubState);
					else if (nextState != null && nextSubState != null)
						throw "WHAT!? Why `state` and `subState` are not NULL? Check please, one of these want a NULL.";
				});
			}
			else
			{
				FlxTween.tween(spr, {alpha: 0.001}, 0.4, {
					ease: FlxEase.quadOut,
				});
			}
		});
	}

	function addBottomText(axisY:Float, text:String):Void
	{
		var bottomText:FlxText = new FlxText(5, axisY, FlxG.width - 10, text, 12);
		bottomText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		bottomText.scrollFactor.set();
		add(bottomText);
	}

	function changeSelection(?n:Int = 0, ?playSound:Bool = true):Void
	{
		if (playSound)
			Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu', null, false)));

		menuGrp.members[curSelected].playAnim('idle');
		menuGrp.members[curSelected].updateHitbox();
		menuGrp.members[curSelected].screenCenter(X);

		curSelected = FlxMath.wrap(curSelected + n, 0, ITEMS.length - 1);

		menuGrp.members[curSelected].playAnim('selected');
		menuGrp.members[curSelected].centerOffsets();
		menuGrp.members[curSelected].screenCenter(X);

		camObject.setPosition(menuGrp.members[curSelected].getGraphicMidpoint().x,
			(menuGrp.members[curSelected].getGraphicMidpoint().y + 50) - (ITEMS.length > 4 ? 15 : 75));
	}
}
