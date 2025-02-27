package engine.ui.debug;

import engine.backend.Conductor;
import engine.ui.debug.charting.*;
import funkin.backend.song.ChartFile;
import funkin.backend.song.MetaFile;
import tempo.ui.interfaces.ITempoUI;
import tempo.ui.interfaces.ITempoUIState;

class ChartEditorState extends EditorState implements ITempoUIState
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

	var gridBG:FlxSprite;
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

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 9, GRID_SIZE * 16);
		gridBG.antialiasing = false;
		gridBG.screenCenter();
		add(gridBG);

		strumLine = new FlxSprite(gridBG.x).makeGraphic(Std.int(gridBG.width), 4, FlxColor.RED);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		addSection();

		updateGrid();

		loadSong(metaData.songName.toFolderCase());
		Conductor.instance.bpm = metaData.bpm;
		Conductor.instance.changeMapBPM(chartData, metaData, curDifficulty);

		super.create();

		camGrid.follow(strumLine);

		updateWindow('--C Chart Editor', 'icon-1', ["Chart Editor", null, null, null, 'chart-editor', "Charting"]);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(FlxAssets.getSound('songs:assets/songs/${daSong}/Inst.ogg'), 0.6);
		FlxG.sound.music.pause();
	}

	function getStrumTime(yPos:Float):Float
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.instance.stepCrochet);

	function getYFromStrum(time:Float):Float
		return FlxMath.remapToRange(time, 0, 16 * Conductor.instance.stepCrochet, gridBG.y, gridBG.y + gridBG.height);

	function updateGrid():Void {}

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

		trace(chartData.sections.toString());
	}

	override function update(elapsed:Float):Void
	{
		final curMouse:FlxMouse = FlxG.mouse;

		if (FlxG.sound.music.time < 0)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
		}
		else if (FlxG.sound.music.time > FlxG.sound.music.length)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = FlxG.sound.music.endTime - 728;
		}

		Conductor.instance.songPos = FlxG.sound.music.time;

		strumLine.y = getYFromStrum((Conductor.instance.songPos - sectionStartTime()) % (Conductor.instance.stepCrochet * 16));

		if (curBeat % 4 == 0 && curStep >= 16 * (curEditSection + 1))
		{
			if (chartData.sections.get(curDifficulty)[curEditSection + 1] == null)
				addSection();

			changeSection(curEditSection + 1, false);
		}

		if (!tempoUIFocused)
		{
			if (FlxG.mouse.x > gridBG.x
				&& FlxG.mouse.x < gridBG.x + gridBG.width
				&& FlxG.mouse.y > gridBG.y
				&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * getSectionBeats() * 4) * zoomList[curZoom])
			{
				dummyArrow.x = Math.floor(FlxG.mouse.viewX / GRID_SIZE) * GRID_SIZE;
				if (FlxG.keys.pressed.SHIFT)
					dummyArrow.y = FlxG.mouse.y;
				else
					dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
			}

			if (TempoInput.keyJustPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
					FlxG.sound.music.pause();
				else
					FlxG.sound.music.play();
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.instance.stepCrochet * .4);
			}

			if (TempoInput.keyJustPressed.HOME)
				FlxTween.tween(FlxG.sound.music, {time: 0}, 1, {ease: FlxEase.cubeInOut});
			else if (TempoInput.keyJustPressed.END)
				FlxTween.tween(FlxG.sound.music, {time: FlxG.sound.music.endTime - 728}, 1, {ease: FlxEase.cubeInOut});
		}

		super.update(elapsed);
	}

	var mouseCount:Int = 0;

	function overlapedToUpper(value:Bool->Void):Void
	{
		final mouseOverlapedToUpper:Bool = TempoInput.cursorOverlaps(upperBoxHitbox, camHUD);

		if (mouseOverlapedToUpper && mouseCount < 1)
		{
			mouseCount++;

			value(true);
		}
		else if (!mouseOverlapedToUpper && mouseCount == 1)
		{
			mouseCount = 0;

			value(false);
		}
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
	}

	var upperBoxHitbox:TempoSprite;
	var upperBoxList:TempoUIList;

	function addUpperStuff():Void
	{
		var upper:TempoSprite = new TempoSprite(-1);
		upper.makeGraphic(FlxG.width + 2, 40, TempoUIConstants.COLOR_BASE_BG);
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

		upperBoxHitbox = new TempoSprite(upper.x, upper.y);
		upperBoxHitbox.makeGraphic(Std.int(upper.width), Std.int(upper.height), FlxColor.TRANSPARENT);
		upperBoxHitbox.alpha = .001;
		upperBoxHitbox.cameras = [camHUD];
		upperBoxHitbox.zIndex = 8;
		add(upperBoxHitbox);
	}

	function reloadBGColor():TempoSprite
	{
		bg.color = FlxColor.fromRGB(Save.editorData.bgColor.r, Save.editorData.bgColor.g, Save.editorData.bgColor.b);
		return bg;
	}

	function getSectionBeats(?section:Int):Int
	{
		if (section == null)
			section = curEditSection;
		var val:Null<Float> = null;

		if (chartData.sections.get(curDifficulty)[section] != null)
			val = chartData.sections.get(curDifficulty)[section].beats;

		return val != null ? Std.int(val) : 4;
	}

	public function getEvent(name:String, sender:ITempoUI)
	{
		trace(name + ' {${Std.string(sender)}}');
	}

	var tempoUIFocused:Bool = false;

	public function getFocus(value:Bool, thing:ITempoUI)
	{
		if (thing != null)
			tempoUIFocused = value;
	}
}
