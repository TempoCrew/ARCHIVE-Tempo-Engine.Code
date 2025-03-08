package funkin.ui.menus;

import funkin.objects.AtlasText;
import funkin.data.Update;
import engine.backend.util.SoundUtil;
import engine.backend.Conductor;
import engine.backend.shaders.ColorSwap;
import flixel.group.FlxGroup;

class TitleState extends MusicBeatState
{
	public static var instance:TitleState;

	static var inited:Bool = false;
	static var flashed:Bool = false;

	var credTextShit:FlxText;

	var curWacky:Array<String> = [];
	var wackyImage:FlxSprite;

	var bg:TempoSprite;
	var logo:TempoSprite;
	var gfDance:TempoSprite;
	var titleText:TempoSprite;

	var swagShader:ColorSwap;

	var confirmSound:FlxSound;

	var credGroup:FlxGroup;
	var textGroup:FlxGroup;

	var ngSpr:TempoSprite;
	var blackscreen:TempoSprite;

	override function create()
	{
		super.create();

		instance = this;
		curWacky = FlxG.random.getObject(getIntroTextShit());

		#if FEATURE_CHECKING_UPDATE
		if (Save.optionsData.updatesCheck)
			funkin.data.Update.check();
		#end

		if (!inited)
		{
			persistentDraw = true;
			persistentUpdate = true;

			new FlxTimer().start(1, (t:FlxTimer) ->
			{
				start();
			});
		}
		else
			start();
	}

	function start()
	{
		DiscordClient.instance.changePresence({details: "Title Screen"});

		confirmSound = new FlxSound();
		swagShader = new ColorSwap();

		startMusic();
		Conductor.instance.bpm = 102;
		inited = true;

		if (flashed)
			this.camera.flash(FlxColor.WHITE, 4);

		persistentUpdate = true;

		// yes, game bg is too BLACK, but this for modding lol
		bg = new TempoSprite(-1, -1);
		bg.makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.BLACK);
		bg.screenCenter();
		add(bg);

		gfDance = new TempoSprite(FlxG.width * .4, FlxG.height * .07, ANIMATE);
		gfDance.makeSparrowAtlas({
			path: Paths.image('gfDanceTitle'),
			animations: [
				{name: "danceLeft", prefix: 'gfDance', indices: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]},
				{name: "danceRight", prefix: 'gfDance', indices: [15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 26, 27, 28, 29]}
			]
		});
		trace(gfDance.animation.getAnimationList());

		logo = new TempoSprite(-150, -100, ANIMATE);
		logo.makeSparrowAtlas({
			path: Paths.image('logoBumpin'),
			animations: [{name: 'bump', prefix: 'logo bumpin'}]
		});
		add(logo);
		add(gfDance);

		titleText = new TempoSprite(100, FlxG.height * .8, ANIMATE);
		titleText.makeSparrowAtlas({
			path: Paths.image('titleEnter'),
			animations: [
				{name: "idle", prefix: "Press Enter to Begin", looped: true},
				{name: "press", prefix: "ENTER PRESSED", looped: true}
			]
		});
		titleText.playAnim('idle');
		titleText.updateHitbox();
		add(titleText);

		if (!flashed)
		{
			credGroup = new FlxGroup();
			add(credGroup);
		}
		textGroup = new FlxGroup();

		blackscreen = new TempoSprite(-1, -1);
		blackscreen.makeGraphic(FlxG.width + 2, FlxG.height + 2, FlxColor.BLACK);
		blackscreen.screenCenter();
		if (credGroup != null)
		{
			credGroup.add(blackscreen);
			credGroup.add(textGroup);
		}

		ngSpr = new TempoSprite(0, FlxG.height * 0.52, GRAPHIC);

		if (FlxG.random.bool(1))
			ngSpr.makeImage({path: Paths.image("newgrounds_logo_classic")});
		else if (FlxG.random.bool(30))
		{
			ngSpr.makeImage({
				path: Paths.image("newgrounds_logo_animated"),
				animated: true,
				frameWidth: 600,
				animations: [['idle', [0, 1], [4]]]
			});
			ngSpr.animation.play('idle', true);
			ngSpr.setGraphicSize(ngSpr.width * 0.55);
			ngSpr.y += 25;
		}
		else
		{
			ngSpr.makeImage({path: Paths.image('newgrounds_logo')});
			ngSpr.setGraphicSize(ngSpr.width * 0.8);
		}

		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);

		gfDance.shader = swagShader.shader;
		logo.shader = swagShader.shader;
		titleText.shader = swagShader.shader;

		try
			confirmSound.loadEmbedded(Paths.loader.sound(Paths.sound('confirmMenu')))
		catch (e)
			trace(e.message);

		FlxG.sound.list.add(confirmSound);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Paths.loader.text('preload:assets/data/introText.txt');

		var firstArray:Array<String> = fullText.split('\n').filter((s:String) -> return s != '');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
			swagGoodArray.push(i.split('--'));

		return swagGoodArray;
	}

	function startMusic():Void
	{
		if (!inited)
			if (FlxG.sound.music == null)
				FlxG.sound.playMusic(Paths.loader.sound(Paths.music('freakyMenu')), 0);
	}

	function createCoolText(value:Array<String>):Void
	{
		if (credGroup == null || textGroup == null)
			return;

		for (i in 0...value.length)
		{
			var money:AtlasText = new AtlasText(0, 0, value[i], BOLD);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			textGroup.add(money);
		}
	}

	function addMoreText(value:String):Void
	{
		if (credGroup == null || textGroup == null)
			return;

		lime.ui.Haptic.vibrate(100, 100);

		var cool:AtlasText = new AtlasText(0, 0, value.trim(), BOLD);
		cool.screenCenter(X);
		cool.y += (textGroup.length * 60) + 200;
		textGroup.add(cool);
	}

	function deleteCoolText():Void
	{
		if (credGroup == null || textGroup == null)
			return;

		while (textGroup.members.length > 0)
			textGroup.remove(textGroup.members[0], true);
	}

	var lastBeat:Int = 0;
	var danceLeft:Bool = false;

	override function beatHit():Void
	{
		super.beatHit();

		if (!flashed)
		{
			if (curBeat > lastBeat)
			{
				for (i in lastBeat...curBeat)
				{
					switch (i + 1)
					{
						case 1:
							createCoolText(['The', 'MrzkTeam']);
						case 3:
							addMoreText('presents');
						case 4:
							deleteCoolText();
						case 5:
							createCoolText(["Out of association", 'with']);
						case 7:
							addMoreText('newgrounds');
							if (ngSpr != null)
								ngSpr.visible = true;
						case 8:
							deleteCoolText();
							if (ngSpr != null)
								ngSpr.visible = false;
						case 9:
							createCoolText([curWacky[0]]);
						case 11:
							addMoreText(curWacky[1]);
						case 12:
							deleteCoolText();
						case 13:
							addMoreText('Friday');
						case 14:
							addMoreText('Night');
						case 15:
							addMoreText('Funkin');
						case 16:
							flashing();
					}
				}
			}

			lastBeat = curBeat;
		}
		else
		{
			if (logo != null)
				logo.playAnim('bump', true);

			if (gfDance != null && gfDance.animation != null)
			{
				danceLeft = !danceLeft;

				if (danceLeft)
					gfDance.playAnim('danceLeft');
				else
					gfDance.playAnim('danceRight');
			}
		}
	}

	var accepted:Bool = false;
	var mustSkip:Bool = false;
	var pitchStuff:Bool = true;
	var acceptTime:FlxTimer;

	override function update(el:Float)
	{
		FlxG.bitmapLog.add(FlxG.camera.buffer);

		#if FLX_PITCH
		if (pitchStuff)
		{
			if (FlxG.keys.pressed.UP)
				FlxG.sound.music.pitch += 0.1;
			if (FlxG.keys.pressed.DOWN)
				FlxG.sound.music.pitch -= 0.1;
		}
		#end

		if (TempoInput.keyPressed.A)
			swagShader.hue += 0.001;
		if (TempoInput.keyPressed.D)
			swagShader.hue -= 0.001;

		SoundUtil.updateVolume({
			sound: FlxG.sound.music,
			addVolume: 0.25,
			toVolume: 0.8,
			elapsed: el
		});

		if (FlxG.sound.music != null)
			Conductor.instance.songPos = FlxG.sound.music.time;

		if (inited)
		{
			if (!accepted)
			{
				if (player1.controls.ACCEPT)
				{
					if (!flashed)
					{
						flashing();
						return;
					}

					pitchStuff = false;
					accepted = true;
					this.camera.flash();

					if (confirmSound != null)
						confirmSound.play();

					titleText.playAnim('press', true);
					new FlxTimer().start(0.1, (_) -> mustSkip = true);
					acceptTime = new FlxTimer().start(2, (t:FlxTimer) ->
					{
						t = null;
						goToMenu();
					});
				}
			}
			else
			{
				// For modders, who working 24/7 - this will be added a time for next section
				if (mustSkip && player1.controls.ACCEPT)
				{
					mustSkip = false;

					if (confirmSound != null && confirmSound.playing)
						confirmSound.stop();
					if (acceptTime != null)
						acceptTime.cancel();

					goToMenu();
				}
			}
		}

		super.update(el);
	}

	static var updaterPushed:Bool = false;

	function goToMenu():Void
	{
		if (Update.userMustUpdate && !updaterPushed)
		{
			updaterPushed = true;

			FlxG.state.persistentUpdate = false;
			FlxG.state.openSubState(new engine.ui.UpdateSubState(Update.newUpdate, () ->
			{
				FlxG.state.persistentUpdate = true;

				new FlxTimer().start(0.2, (_) -> TempoState.switchState(new funkin.ui.menus.MainMenuState()));
			}));
		}
		else
			TempoState.switchState(new funkin.ui.menus.MainMenuState());
	}

	static function flashing():Void
	{
		if (!flashed)
		{
			@:privateAccess {
				TitleState.instance.remove(TitleState.instance.ngSpr);
				TitleState.instance.camera.flash();
				TitleState.instance.remove(TitleState.instance.credGroup);
			}

			flashed = true;
		}
	}
}
