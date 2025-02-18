package engine.ui.debug;

import engine.types.ListData;
import tempo.ui.TempoUIList;
import lime.graphics.Image;
import funkin.ui.menus.TitleState;
import tempo.ui.TempoUIListButton;
import tempo.TempoSprite;

class ChartEditorState extends flixel.FlxState
{
	public static var instance(get, never):ChartEditorState;
	static var _instance:Null<ChartEditorState> = null;

	var file_listButton:TempoUIListButton;
	var edit_listButton:TempoUIListButton;
	var view_listButton:TempoUIListButton;
	var audio_listButton:TempoUIListButton;
	var tools_listButton:TempoUIListButton;
	var help_listButton:TempoUIListButton;

	var file_listBox:TempoUIList;

	var listButtons:Array<TempoUIListButton> = [];
	var listBoxes:Array<TempoUIList> = [];

	var camEditor:FlxCamera;
	var camHUD:FlxCamera;
	var camWindow:FlxCamera;
	var camMenu:FlxCamera;

	public function new():Void
	{
		super();
	}

	override function create():Void
	{
		addCameras();
		getWindowData();

		var bg:TempoSprite = new TempoSprite(-5, -5, GRAPHIC).makeImage({
			path: Paths.image('menuDesat'),
			width: 1290,
			height: 730,
			color: FlxColor.PURPLE
		});
		bg.scrollFactor.set();
		add(bg);

		addUpperBox();
		addListButton();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (TempoInput.keyJustPressed.BACKSPACE)
		{
			DiscordClient.instance.changePresence();
			FlxG.switchState(() -> new TitleState());
		}

		if (listButtons.length != 0 && listBoxes.length != 0)
		{
			for (i in 0...listButtons.length)
			{
				if (listButtons[i].bg.alpha >= 1)
					listBoxes[i].visible = true;
				else
					listBoxes[i].visible = false;
			}
		}

		// if (file_listButton.bg.alpha >= 1)
		//	file_listBox.visible = true;
		// else
		//	file_listBox.visible = false;

		super.update(elapsed);
	}

	function addListButton():Void
	{
		final fileData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.file.json')));
		final editData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.edit.json')));
		final audioData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.audio.json')));
		final viewData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.view.json')));
		final toolsData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.tools.json')));
		final pluginsData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.plugins.json')));
		final helpData:ListData = TJSON.parse(File.getContent(Paths.engine('ui/data/chart.help.json')));

		listButtons.push(new TempoUIListButton(5, "File"));
		listBoxes.push(new TempoUIList(listButtons[0].bg.x, getListY(listButtons[0]), [
			{
				type: HOVER,
				text: "Test Hover",
				tag: "Test",
				hoverData: [{type: BUTTON, text: "GOVNO", tag: "govno"}]
			}
		]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[0]) + 1, "Edit"));
		listBoxes.push(new TempoUIList(listButtons[1].bg.x, getListY(listButtons[1]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[1]) + 1, "Audio"));
		listBoxes.push(new TempoUIList(listButtons[2].bg.x, getListY(listButtons[2]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[2]) + 1, "View"));
		listBoxes.push(new TempoUIList(listButtons[3].bg.x, getListY(listButtons[3]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[3]) + 1, "Tools"));
		listBoxes.push(new TempoUIList(listButtons[4].bg.x, getListY(listButtons[4]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[4]) + 1, "Plugins"));
		listBoxes.push(new TempoUIList(listButtons[5].bg.x, getListY(listButtons[5]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));
		listButtons.push(new TempoUIListButton(getListX(listButtons[5]) + 1, "Help"));
		listBoxes.push(new TempoUIList(listButtons[6].bg.x, getListY(listButtons[6]), [{type: BUTTON, text: "TeST", tag: "TEst"}]));

		listButtons[0].others = [
			listButtons[1],
			listButtons[2],
			listButtons[3],
			listButtons[4],
			listButtons[5],
			listButtons[6]
		];
		listButtons[1].others = [
			listButtons[0],
			listButtons[2],
			listButtons[3],
			listButtons[4],
			listButtons[5],
			listButtons[6]
		];
		listButtons[2].others = [
			listButtons[1],
			listButtons[0],
			listButtons[3],
			listButtons[4],
			listButtons[5],
			listButtons[6]
		];
		listButtons[3].others = [
			listButtons[1],
			listButtons[2],
			listButtons[0],
			listButtons[4],
			listButtons[5],
			listButtons[6]
		];
		listButtons[4].others = [
			listButtons[1],
			listButtons[2],
			listButtons[3],
			listButtons[0],
			listButtons[5],
			listButtons[6]
		];
		listButtons[5].others = [
			listButtons[1],
			listButtons[2],
			listButtons[3],
			listButtons[4],
			listButtons[0],
			listButtons[6]
		];
		listButtons[6].others = [
			listButtons[1],
			listButtons[2],
			listButtons[3],
			listButtons[4],
			listButtons[5],
			listButtons[0]
		];

		for (i in 0...listButtons.length)
		{
			listButtons[i].cameras = [camHUD];
			add(listButtons[i]);

			listBoxes[i].cameras = [camHUD];
			add(listBoxes[i]);
		}
	}

	function getListX(prev:TempoUIListButton):Float
		return prev.bg.x + prev.bg.width;

	function getListY(prev:TempoUIListButton):Float
		return prev.bg.y + prev.bg.height;

	function addCameras():Void
	{
		camEditor = new FlxCamera();
		camHUD = new FlxCamera();
		camWindow = new FlxCamera();
		camMenu = new FlxCamera();

		camEditor.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;
		camWindow.bgColor.alpha = 0;
		camMenu.bgColor.alpha = 0;

		FlxG.cameras.reset(camEditor);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camWindow, false);
		FlxG.cameras.add(camMenu, false);
	}

	function addUpperBox():Void
	{
		var upperBox_1:TempoSprite = new TempoSprite().makeRoundRectComplex({
			width: FlxG.width + 1,
			height: 41,
			color: Constants.COLOR_EDITOR_UPPERBOX_LIGHT,
			roundRect: {elBottomLeft: 2.5, elBottomRight: 2.5}
		});
		upperBox_1.scrollFactor.set();
		upperBox_1.cameras = [camHUD];
		add(upperBox_1);

		var upperBox:TempoSprite = new TempoSprite().makeRoundRectComplex({
			width: FlxG.width + 1,
			height: 40,
			color: Constants.COLOR_EDITOR_UPPERBOX,
			roundRect: {elBottomLeft: 5, elBottomRight: 5}
		});
		upperBox.scrollFactor.set();
		upperBox.cameras = [camHUD];
		add(upperBox);
	}

	var curSong:String = 'test';

	function getWindowData():Void
	{
		Application.current.window.title = "Chart Editor - " + curSong.toFolderCase() + "." + Constants.EXT_CHART + "";
		Application.current.window.setIcon(Image.fromFile(Paths.image('ui/icon-1.${Constants.EXT_DEBUG_IMAGE}')));
		DiscordClient.instance.changePresence({
			details: "Editing " + curSong.toFolderCase() + "." + Constants.EXT_CHART,
			largeImageKey: "chart-editor",
			largeImageText: "Chart Editor",
			smallImageText: "BF (Week 6)",
			smallImageKey: "bf-pixel"
		});
	}

	static function get_instance():ChartEditorState
	{
		if (ChartEditorState._instance == null)
			_instance = new ChartEditorState();
		if (ChartEditorState._instance == null)
			throw "Could not initialize singleton ChartEditorState";
		return ChartEditorState._instance;
	}
}
