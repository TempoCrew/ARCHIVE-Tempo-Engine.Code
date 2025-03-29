package funkin.ui.options;

import funkin.objects.Checkboxer;
import funkin.ui.menus.OptionsState;
import engine.backend.util.SoundUtil;
import flixel.addons.text.FlxTypeText;
import funkin.ui.options.backend.Setting;
import funkin.objects.TextMenuList.TextMenuItem;

@:access(funkin.ui.menus.OptionsState)
class BaseSubState extends MusicBeatSubState
{
	var curSelected:Int = 0;

	public var name(default, null):String;
	public var settings:Array<Setting>;

	var tweens:Array<FlxTween> = [];

	var optionGrp:FlxSpriteGroup;
	var bottomText:FlxText;

	var camBase:FlxCamera;
	var camFollow:FlxObject;

	var _maxWidth:Int;

	public function new(name:String):Void
	{
		super();

		camBase = new FlxCamera();
		camBase.bgColor.alpha = 0;
		FlxG.cameras.add(camBase);

		this.name = name;
		this.camera = camBase;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		camBase.follow(camFollow, LOCKON, 0.12);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 80, 80, true, FlxColor.WHITE, FlxColor.TRANSPARENT));
		grid.alpha = .001;
		grid.velocity.set(25, 25);
		grid.scrollFactor.set();
		FlxTween.tween(grid, {alpha: .175}, 0.4, {ease: FlxEase.quadInOut});
		add(grid);

		optionGrp = new FlxSpriteGroup();
		add(optionGrp);

		for (i in 0...settings.length)
		{
			var itemGrp:FlxSpriteGroup = new FlxSpriteGroup(25, 100 + (i * 100));

			if (settings[i].name.length > _maxWidth)
				_maxWidth = settings[i].name.length;

			if (settings[i].type == BOOL)
			{
				var check:Checkboxer = new Checkboxer(0, 0, Reflect.getProperty(Save.optionsData, settings[i].variable));
				itemGrp.add(check);

				var child:TextMenuItem = new TextMenuItem(125, 25, settings[i].name, BOLD);
				child.alpha = 1.;
				itemGrp.add(child);
			}
			else if (settings[i].type == INT)
			{
				var child:TextMenuItem = new TextMenuItem(0, 25, settings[i].name + ': < ${Reflect.getProperty(Save.optionsData, settings[i].variable)} >',
					DEFAULT);
				child.alpha = 1.;
				itemGrp.add(child);
			}
			else if (settings[i].type == FLOAT)
			{
				var child:TextMenuItem = new TextMenuItem(0, 25, settings[i].name, BOLD);
				child.alpha = 1.;
				itemGrp.add(child);
			}
			else if (settings[i].type == PERCENT)
			{
				var child:TextMenuItem = new TextMenuItem(0, 25, settings[i].name + ': ', DEFAULT);
				child.alpha = 1.;
				itemGrp.add(child);
			}
			else if (settings[i].type == STR)
			{
				var child:TextMenuItem = new TextMenuItem(0, 25,
					settings[i].name + ': < ' + Reflect.getProperty(Save.optionsData, settings[i].variable) + ' >', DEFAULT);
				child.alpha = 1.;
				itemGrp.add(child);
			}

			itemGrp.alpha = .6;
			optionGrp.add(itemGrp);

			tweens.push(null);
		}

		descBox = new TempoSprite(95, 580, ROUND_RECT);
		descBox.makeRoundRect({
			width: 1090,
			height: 70,
			color: FlxColor.BLACK,
			elWidth: 10,
			elHeight: 10
		});
		descBox.alpha = .001;
		descBox.scrollFactor.set();
		add(descBox);

		descText = new FlxTypeText(descBox.x + 5, descBox.y + 5, Std.int(descBox.width - 5), "", 26);
		descText.fieldWidth = descBox.width - 5;
		descText.setFormat(Paths.font('phantomMuff.ttf'), 26, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		descText.sounds = [SoundUtil.loadFlxSound(Paths.sound('scrollMenu.ogg'), 0.4)];
		descText.alpha = .001;
		descText.scrollFactor.set();
		add(descText);

		var bottomBG:FlxSprite = new FlxSprite(-1, FlxG.height - 26).makeGraphic(FlxG.width + 2, FlxG.height + 30, FlxColor.BLACK);
		bottomBG.alpha = .001;
		bottomBG.scrollFactor.set();
		add(bottomBG);

		bottomText = new FlxText(5, FlxG.height - 22, FlxG.width, "", 16);
		bottomText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE);
		bottomText.scrollFactor.set();
		add(bottomText);

		var item:TextMenuItem = new TextMenuItem(25, 25, name, BOLD);
		item.scrollFactor.set();
		item.alpha = 1.0;
		add(item);

		descBox.x += 50;
		descText.x += 50;

		FlxTween.tween(bottomBG, {alpha: .6}, 0.4, {ease: FlxEase.quadInOut});
		FlxTween.tween(descBox, {x: descBox.x - 50, alpha: .6}, 0.4, {ease: FlxEase.quadInOut});
		FlxTween.tween(descText, {x: descText.x - 50, alpha: 1.}, 0.4, {ease: FlxEase.quadInOut});

		changeSelection(0, false);
	}

	var descBox:TempoSprite;
	var descText:FlxTypeText;

	override function create():Void
	{
		#if FEATURE_DISCORD_RPC
		DiscordClient.instance.changePresence({details: "Options Menu", state: name});
		#end

		super.create();
	}

	function restartDesc(text:String, rec:String):Void
	{
		if (!descText.paused)
			descText.skip();

		bottomText.text = rec;

		descText.prefix = "";
		descText.resetText(text);
		descText.start();
	}

	override function close():Void
	{
		OptionsState.instance.itemsReturn();

		super.close();
	}

	override function update(elapsed:Float):Void
	{
		if (player1.controls.BACK)
		{
			Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu.ogg')));
			close();
		}

		if (player1.controls.UI_UP_P)
			changeSelection(-1);
		if (player1.controls.UI_DOWN_P)
			changeSelection(1);

		super.update(elapsed);
	}

	function changeSelection(n:Int = 0, ?playSound:Bool = true)
	{
		if (playSound)
			Tempo.playSound(Paths.loader.sound(Paths.sound('scrollMenu.ogg')));

		optionGrp.members[curSelected].alpha = .6;

		curSelected = FlxMath.wrap(curSelected + n, 0, settings.length - 1);

		optionGrp.members[curSelected].alpha = 1.;
		camFollow.setPosition(optionGrp.members[curSelected].x + (FlxG.width / 2.4), optionGrp.members[curSelected].y + 120);

		restartDesc(settings[curSelected].desc, settings[curSelected].rec);
	}
}
