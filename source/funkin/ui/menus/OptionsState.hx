package funkin.ui.menus;

import funkin.objects.TextMenuList;
import funkin.ui.options.*;

class OptionsState extends MusicBeatState
{
	final bgColors:Array<FlxColor> = [0xFF663914, 0xFF0F4980, 0xFF4D1666, 0xFF000000, 0xFF0F4105, 0xFF000000];
	final list:Array<String> = ["Performance", "Controls", "Gameplay", "Input Offset", "Miscellaneous", "Exit"];

	function switchBoobs(label:String):Void
	{
		switch (label.toLowerCase())
		{
			case 'performance':
				FlxG.state.openSubState(new PerformanceSubState());
			case 'controls':
				FlxG.state.openSubState(new ControlsSubState());
			case 'miscellaneous':
				FlxG.state.openSubState(new MiscSubState());
			case 'gameplay':
				FlxG.state.openSubState(new GameplaySubState());
			case "input offset":
				TempoState.switchState(new InputOffsetState());
			default:
				TempoState.switchState(new MainMenuState());
		}
	}

	function getSubMenu(label:String):Bool
	{
		if (label == 'performance' || label == 'controls' || label == 'gameplay' || label == 'miscellaneous')
			return true;

		return false;
	}

	public static var instance:OptionsState = null;

	var menuLists:FlxTypedGroup<TextMenuItem>;
	var bg:TempoSprite;

	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Options Menu"});
		#end

		bg = new TempoSprite();
		bg.makeImage({path: Paths.image('menuDesat', null, false)});
		bg.screenCenter();
		bg.color = FlxColor.MAGENTA;
		bg.scrollFactor.set();
		add(bg);

		menuLists = new FlxTypedGroup<TextMenuItem>();
		add(menuLists);

		for (i in 0...list.length)
		{
			var item:TextMenuItem = new TextMenuItem(0, 102 + (i * 79), list[i], BOLD);
			item.screenCenter(X);
			item.alpha = .6;
			item.zIndex = i;
			item.scrollFactor.set();
			item.originAxisX = item.x;
			item.originAxisY = item.y;
			menuLists.add(item);
		}

		instance = this;

		super.create();

		changeSelection(0, false);
	}

	var uiSelected:Bool = false;
	var holdTime:Float = .0;

	override function update(elapsed:Float):Void
	{
		if (!uiSelected)
		{
			engine.backend.util.SoundUtil.updateVolume({
				sound: FlxG.sound.music,
				toVolume: .7,
				addVolume: .5,
				elapsed: elapsed
			});

			if (player1.controls.BACK)
			{
				uiSelected = true;
				Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu', null, false)));
				TempoState.switchState(new MainMenuState());
			}
			else if (player1.controls.ACCEPT)
			{
				uiSelected = true;
				Tempo.playSound(Paths.loader.sound(Paths.sound('confirmMenu', null, false)));
				select();
			}

			if (player1.controls.UI_DOWN_P)
			{
				changeSelection(1);
				holdTime = 0;
			}
			if (player1.controls.UI_UP_P)
			{
				changeSelection(-1);
				holdTime = 0;
			}

			if (player1.controls.UI_DOWN || player1.controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold));
			}

			if (TempoInput.cursorWheelMoved)
			{
				Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu', null, false)), 0.2);
				changeSelection(-FlxG.mouse.wheel, false);
			}
		}

		super.update(elapsed);
	}

	function select():Void
	{
		final name:String = list[currentSelected].toLowerCase();
		final isSubMenu:Bool = getSubMenu(name);

		if (isSubMenu)
		{
			FlxTween.color(bg, 0.7, FlxColor.MAGENTA, bgColors[currentSelected], {
				ease: FlxEase.quadInOut,
				onComplete: (t) ->
				{
					t = null;
					bg.color = bgColors[currentSelected];
				}
			});
		}

		menuLists.forEach((spr:TextMenuItem) ->
		{
			if (spr.zIndex == currentSelected)
			{
				if (Save.optionsData.flashing)
					FlxFlicker.flicker(spr, 1, 0.06, false, false);

				if (isSubMenu)
				{
					FlxTween.tween(spr, {x: 25, y: 25}, 0.7, {
						ease: FlxEase.quadInOut,
						onComplete: (t:FlxTween) ->
						{
							t = null;
						}
					});
				}
			}
			else
			{
				FlxTween.tween(spr, {alpha: .001}, 0.3, {
					ease: FlxEase.circOut,
					onComplete: (t) ->
					{
						t = null;
					}
				});
			}
		});

		new FlxTimer().start(1, (_) ->
		{
			_ = null;

			switchBoobs(name);
		});
	}

	function itemsReturn():Void
	{
		if (bg.color != FlxColor.MAGENTA)
		{
			final leColor:FlxColor = bg.color;

			FlxTween.color(bg, 0.2, leColor, FlxColor.MAGENTA, {
				ease: FlxEase.quadOut,
				onComplete: (t) ->
				{
					t = null;
					bg.color = FlxColor.MAGENTA;
				}
			});
		}

		for (i in 0...menuLists.members.length)
		{
			menuLists.members[i].visible = true;
			FlxTween.tween(menuLists.members[i],
				{alpha: (i == currentSelected ? 1. : .6), x: menuLists.members[i].originAxisX, y: menuLists.members[i].originAxisY}, 0.2, {
					ease: FlxEase.quadInOut,
					onComplete: (t) ->
					{
						t = null;
					}
				});
		}

		new FlxTimer().start(.2, (t) ->
		{
			changeSelection(0, false);
			uiSelected = false;

			t = null;
		});
	}

	static var currentSelected:Int = 0;

	function changeSelection(?n:Int = 0, ?playSound:Bool = true):Void
	{
		if (playSound)
			Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu.ogg')));

		menuLists.members[currentSelected].alpha = .6;
		currentSelected = FlxMath.wrap(currentSelected + n, 0, list.length - 1);
		menuLists.members[currentSelected].alpha = 1.;
	}
}
