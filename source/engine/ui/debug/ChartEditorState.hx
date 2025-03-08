package engine.ui.debug;

import tempo.types.TempoOffset;
import engine.backend.Conductor;
import engine.ui.debug.charting.*;
import funkin.backend.song.ChartFile;
import funkin.backend.song.MetaFile;
import tempo.ui.interfaces.ITempoUI;

class ChartEditorState extends EditorState
{
	public static var instance:Null<ChartEditorState> = null;

	public var curDifficulty:String = "normal";

	public static var chartData(default, set):ChartFile = null;

	static function set_chartData(v:ChartFile):ChartFile
	{
		chartData = v;

		return chartData;
	}

	public static var metaData(default, set):MetaFile = null;

	static function set_metaData(v:MetaFile):MetaFile
	{
		metaData = v;

		return metaData;
	}

	var quantList:Array<Int> = [4, 8, 12, 16, 20, 24, 32, 48, 64, 96, 192];
	var curQuant:Int = 0;

	var zoomList:Array<Float> = [0.25, 0.5, 1.0, 1.5, 2, 4, 6, 8, 12, 16];
	var curZoom:Int = 2;

	public function new(?chartData:ChartFile, ?metaData:MetaFile):Void
	{
		super(CHART);

		if (chartData != null)
			ChartEditorState.chartData = chartData;
		if (metaData != null)
			ChartEditorState.metaData = metaData;
	}

	var bg:Null<TempoSprite> = null;

	function addBG():Void
	{
		bg = new TempoSprite(0, 0, GRAPHIC).makeImage({path: Paths.image('menuDesat')});
		bg.setGraphicSize(bg.width * 1.175);
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		reloadBGColor();
		add(bg);
	}

	final GRID_SELECTION_BORDER_WIDTH:Int = 6;

	var prevGridBG:FlxSprite;
	var gridBG:FlxSprite;
	var nextGridBG:FlxSprite;
	final GRID_SIZE:Int = 40;
	var strumLine:FlxSprite;
	var dummyArrow:FlxSprite;

	override function create():Void
	{
		if (chartData == null)
			chartData = {
				scrollSpeeds: ["easy" => 1.0, "normal" => 1.2, "hard" => 1.4],
				notes: ["easy" => [], "normal" => [], "hard" => []],
				sections: ["easy" => [], "normal" => [], "hard" => []]
			};
		if (metaData == null)
			metaData = {
				artist: "Kawai Sprite",
				songName: "Test",
				bpm: 150,
				album: "placeHolder",
				generatedBy: "template",
				charter: "Unknown",
				playData: {
					stage: "mainStage",
					players: ["opponent" => "bf-pixel", "player" => "bf", "gf" => "gf"],
					ratings: ["easy" => 2, "normal" => 3, "hard" => 4],
					difficulties: ["easy", "normal", "hard"],
					uiStyle: "funkin",
					previewStart: 0,
					previewEnd: 14000
				}
			};

		instance = this;

		addCameras();
		addBG();
		addUpperStuff();
		addBottomStuff();

		reloadGridBGs();

		strumLine = new FlxSprite(gridBG.x).makeGraphic(Std.int(gridBG.width), 4, FlxColor.RED);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		loadSong(metaData.songName.toFolderCase());

		if (maxSections != 0)
			for (i in 0...maxSections)
				addSection();

		updateGrid();

		Conductor.instance.bpm = metaData.bpm;
		Conductor.instance.changeMapBPM(chartData, metaData, curDifficulty);

		createWindow('meta', "Chart Metadata");
		createWindow('difficulty', "Difficulties");
		createWindow('offsets', "Song Offsets");
		createWindow('note', "Note Data");
		createWindow('event', "Event Data");
		createWindow('fp', "Freeplay Properties");
		createWindow('pp', "PlayTest Properties");

		super.create();

		camGrid.follow(strumLine);

		updateWindow('--C Chart Editor', 'icon-1', ["Chart Editor", null, null, null, 'chart-editor', "Charting"]);
	}

	var winDisplay:Map<String,
		{
			x:Float,
			y:Float,
			w:Int,
			h:Int
		}> = [
			'meta' => {
				x: 10,
				y: 40,
				w: 250,
				h: 230
			},
			'difficulty' => {
				x: 275,
				y: 45,
				w: 210,
				h: 400
			},
			'offsets' => {
				x: 25,
				y: 275,
				w: 400,
				h: 325
			},
			'note' => {
				x: 600,
				y: 62,
				w: 200,
				h: 300
			},
			'event' => {
				x: 800,
				y: 200,
				w: 200,
				h: 300
			},
			'fp' => {
				x: 10,
				y: 200,
				w: 400,
				h: 400
			},
			'pp' => {
				x: 425,
				y: 120,
				w: 350,
				h: 285
			}
		];
	var windows:Map<String, TempoUIWindow> = [];

	function createWindow(name:String, display:String):Void
	{
		if (windows.exists(name))
			return;

		final dat:
			{
				x:Float,
				y:Float,
				w:Int,
				h:Int
			} = winDisplay.get(name);
		var win:TempoUIWindow = new TempoUIWindow(dat.x, dat.y, display, dat.w, dat.h);
		win.cameras = [camOther];
		win.name = name;
		win.scrollFactor.set();
		win.visible = false;
		add(win);
		windows.set(name, win);
	}

	var maxSections:Int = 0;

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(Paths.loader.sound(Paths.song(daSong, 'Inst')), .6);
		FlxG.sound.music.pause();

		if (FlxG.sound.music != null)
			maxSections = Math.floor(FlxG.sound.music.length / (16 * 100));
	}

	var prevGrp:FlxGroup;
	var nextGrp:FlxGroup;

	function reloadGridBGs():Void
	{
		prevGrp = new FlxGroup();
		add(prevGrp);

		nextGrp = new FlxGroup();
		add(nextGrp);

		prevGridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 16);
		prevGridBG.antialiasing = false;
		prevGridBG.screenCenter(X);
		prevGrp.add(prevGridBG);

		var prevBlackBG:FlxSprite = new FlxSprite(prevGridBG.x).makeGraphic(Std.int(prevGridBG.width), Std.int(prevGridBG.height), FlxColor.BLACK);
		prevBlackBG.antialiasing = false;
		prevBlackBG.alpha = .6;
		prevGrp.add(prevBlackBG);

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 16);
		gridBG.antialiasing = false;
		gridBG.screenCenter();
		add(gridBG);

		prevBlackBG.y = prevGridBG.y = gridBG.y - gridBG.height;

		var previngLine:FlxSprite = new FlxSprite(prevBlackBG.x, prevBlackBG.y + prevBlackBG.height).makeGraphic(Std.int(prevBlackBG.width), 4, FlxColor.BLACK);
		previngLine.antialiasing = false;
		previngLine.alpha = .4;
		prevGrp.add(previngLine);

		nextGridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 16);
		nextGridBG.y = gridBG.y + gridBG.height;
		nextGridBG.antialiasing = false;
		nextGridBG.screenCenter(X);
		nextGrp.add(nextGridBG);

		var nextingLine:FlxSprite = new FlxSprite(nextGridBG.x, nextGridBG.y).makeGraphic(Std.int(nextGridBG.width), 4, FlxColor.BLACK);
		nextingLine.antialiasing = false;
		nextingLine.alpha = .4;
		nextGrp.add(nextingLine);

		var nextBlackBG:FlxSprite = new FlxSprite(nextGridBG.x,
			nextGridBG.y).makeGraphic(Std.int(nextGridBG.width), Std.int(nextGridBG.height), FlxColor.BLACK);
		nextBlackBG.antialiasing = false;
		nextBlackBG.alpha = .6;
		nextGrp.add(nextBlackBG);
	}

	function getStrumTime(yPos:Float):Float
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.instance.stepCrochet);

	function getYFromStrum(time:Float):Float
		return FlxMath.remapToRange(time, 0, 16 * Conductor.instance.stepCrochet, gridBG.y, gridBG.y + gridBG.height);

	function updateGrid():Void
	{
		if (curEditSection < 1)
			prevGrp.visible = false;
	}

	function addSection():Void
	{
		for (diff => section in chartData.sections)
		{
			if (diff == curDifficulty)
			{
				final dat:ChartSectionData = {
					beats: 4
				};

				section.push(dat);
			}
		}
	}

	var mousePressedForTime:Bool = false;

	override function update(elapsed:Float):Void
	{
		final curMouse:FlxMouse = TempoInput.cursor;

		if (FlxG.sound.music.time < 0)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
		}
		else if (FlxG.sound.music.time > FlxG.sound.music.length)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = FlxG.sound.music.length - 728;
		}

		Conductor.instance.songPos = FlxG.sound.music.time;

		strumLine.y = getYFromStrum((Conductor.instance.songPos - sectionStartTime()) % (Conductor.instance.stepCrochet * 16));

		/*
			if (curBeat % 4 == 0 && curStep >= 16 * (curEditSection + 1))
			{
				if (chartData.sections.get(curDifficulty)[curEditSection + 1] == null)
					addSection();

				changeSection(curEditSection + 1, false);
		}*/

		if (strumLine.y > (GRID_SIZE * 16))
		{
			changeSection(curEditSection + 1, false);
		}
		else if (strumLine.y < gridBG.y)
			changeSection(curEditSection - 1, false);

		if (TempoInput.cursorOverlaps(bg, camGrid) && TempoInput.cursorJustPressed_M)
			mousePressedForTime = !mousePressedForTime;

		if (!tempoUIFocused)
		{
			if (!mousePressedForTime)
			{
				if (TempoInput.cursor.x > gridBG.x
					&& TempoInput.cursor.x < gridBG.x + gridBG.width
					&& TempoInput.cursor.y > gridBG.y
					&& TempoInput.cursor.y < gridBG.y + (GRID_SIZE * Conductor.instance.getSectionBeats(chartData, curEditSection,
						curDifficulty) * 4) * zoomList[curZoom])
				{
					dummyArrow.x = Math.floor((TempoInput.cursor.gameX + (GRID_SIZE / 2)) / GRID_SIZE) * GRID_SIZE;
					if (FlxG.keys.pressed.SHIFT)
						dummyArrow.y = TempoInput.cursor.y;
					else
						dummyArrow.y = Math.floor(TempoInput.cursor.y / GRID_SIZE) * GRID_SIZE;
				}

				if (TempoInput.keyJustPressed.SPACE)
				{
					if (FlxG.sound.music.playing)
						FlxG.sound.music.pause();
					else
						FlxG.sound.music.play();
				}

				if (TempoInput.cursorWheelMoved)
				{
					FlxG.sound.music.pause();
					FlxG.sound.music.time -= (TempoInput.cursorWheel * Conductor.instance.stepCrochet * .4);
				}

				if (TempoInput.keyJustPressed.HOME)
					FlxTween.tween(FlxG.sound.music, {time: 0}, 1, {ease: FlxEase.cubeInOut});
				else if (TempoInput.keyJustPressed.END)
					FlxTween.tween(FlxG.sound.music, {time: FlxG.sound.music.length - 728}, 1, {ease: FlxEase.cubeInOut});
			}
			else
			{
				FlxG.sound.music.pause();
				FlxG.sound.music.time -= (TempoInput.cursor.deltaY * .3);
			}
		}

		super.update(elapsed);
	}

	var camGrid:Null<FlxCamera> = null;
	var camHUD:Null<FlxCamera> = null;
	var camOther:Null<FlxCamera> = null;

	function addCameras():Void
	{
		camGrid = new FlxCamera();
		camGrid.bgColor.alpha = 0;
		FlxG.cameras.reset(camGrid);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;
		FlxG.cameras.add(camOther, false);
	}

	function sectionStartTime():Float
	{
		var daBPM:Float = metaData.bpm;
		var daPos:Float = 0;
		for (i in 0...curEditSection)
		{
			if (chartData.sections.get(curDifficulty)[i].changeBPM)
				daBPM = chartData.sections.get(curDifficulty)[i].bpm;

			daPos += 4 * (1000 * 60 / daBPM);
		}

		return daPos;
	}

	var curEditSection:Int = 0;

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		if (chartData.sections.get(curDifficulty)[sec] != null)
		{
			curEditSection = sec;

			updateGrid();
		}
		else
		{
			addSection();

			changeSection(curEditSection - 1, true);
		}
	}

	var upperBoxList:TempoUIList;

	function addUpperStuff():Void
	{
		var upper:TempoSprite = new TempoSprite(-1);
		upper.makeGraphic(FlxG.width + 2, 35, TempoUIConstants.COLOR_BASE_BG);
		upper.scrollFactor.set();
		upper.cameras = [camHUD];
		upper.alpha = 0.915;
		upper.zIndex = 3;
		add(upper);

		var upper2:TempoSprite = new TempoSprite(-1, upper.y + upper.height);
		upper2.makeGraphic(FlxG.width + 2, 1, TempoUIConstants.COLOR_BASE_LINE);
		upper2.scrollFactor.set();
		upper2.cameras = [camHUD];
		upper2.zIndex = 3;
		add(upper2);

		upperBoxList = new TempoUIList(5, 5, ChartingData.ui_list_data);
		upperBoxList.cameras = [camHUD];
		upperBoxList.scrollFactor.set();
		upperBoxList.zIndex = 4;
		add(upperBoxList);
	}

	function addBottomStuff():Void
	{
		var bottom:TempoSprite = new TempoSprite(-1, FlxG.height - 35);
		bottom.makeGraphic(FlxG.width + 2, 36, TempoUIConstants.COLOR_BASE_BG);
		bottom.scrollFactor.set();
		bottom.cameras = [camHUD];
		bottom.alpha = .915;
		bottom.zIndex = 3;
		add(bottom);

		var bottom2:TempoSprite = new TempoSprite(-1, bottom.y - 1);
		bottom2.makeGraphic(FlxG.width + 2, 1, TempoUIConstants.COLOR_BASE_LINE);
		bottom2.scrollFactor.set();
		bottom2.cameras = [camHUD];
		bottom2.zIndex = 3;
		add(bottom2);
	}

	function reloadBGColor():TempoSprite
	{
		bg.color = FlxColor.fromRGB(Save.editorData.bgColor.r, Save.editorData.bgColor.g, Save.editorData.bgColor.b);
		return bg;
	}

	var metaWindow:TempoUIWindow;

	function showWindow(id:String):Void
	{
		for (n => w in windows)
			if (n == id)
				w.visible = true;
	}

	function hideWindow(id:String):Void
	{
		for (n => w in windows)
			if (n == id)
				w.visible = false;
	}

	override function getEvent(name:String, sender:ITempoUI)
	{
		if (name == TempoUIEvents.UI_CHECKBOX_CLICKING)
		{
			var obj:TempoUICheckbox = cast sender;

			switch (obj.name)
			{
				case 'win_metadata':
					if (obj.value)
						showWindow('meta');
					else
						hideWindow('meta');
				default: // nothing
			}
		}

		trace(name + ' {${Std.string(sender.name)}}');
	}

	var tempoUIFocused:Bool = false;

	override function getFocus(value:Bool, thing:ITempoUI)
	{
		if (thing != null)
			tempoUIFocused = value;
	}
}
