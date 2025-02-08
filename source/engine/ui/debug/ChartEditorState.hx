package engine.ui.debug;

import tempo.ui.TempoUIList;
import lime.graphics.Image;
import funkin.ui.menus.TitleState;
import tempo.ui.TempoUIListButton;
import tempo.TempoSprite;

class ChartEditorState extends flixel.FlxState
{
	var file_listButton:TempoUIListButton;
	var edit_listButton:TempoUIListButton;
	var view_listButton:TempoUIListButton;
	var audio_listButton:TempoUIListButton;
	var tools_listButton:TempoUIListButton;
	var help_listButton:TempoUIListButton;

	var file_listBox:TempoUIList;

	var camEditor:FlxCamera;
	var camHUD:FlxCamera;
	var camWindow:FlxCamera;
	var camMenu:FlxCamera;

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

		if (file_listButton.bg.alpha >= 1)
			file_listBox.visible = true;
		else
			file_listBox.visible = false;

		super.update(elapsed);
	}

	function addListButton():Void
	{
		file_listButton = new TempoUIListButton(5, 'File');
		file_listButton.cameras = [camHUD];
		add(file_listButton);

		file_listBox = new TempoUIList(file_listButton.bg.x, getListY(file_listButton), [
			{text: "New Chart...", bind: "CTRL+N"},
			{text: "Open Chart...", bind: "CTRL+O"},
			{text: "Open Recent"},
			null,
			{text: "Save", bind: "CTRL+S"},
			{text: "Save as...", bind: "CTRL+SHIFT+S"},
			null,
			{text: "Import"},
			{text: "Export"},
			null,
			{text: "Exit", bind: "CTRL+F4"}
		]);
		file_listBox.cameras = [camHUD];
		file_listBox.visible = false;
		add(file_listBox);

		edit_listButton = new TempoUIListButton(getListX(file_listButton), 'Edit');
		edit_listButton.cameras = [camHUD];
		add(edit_listButton);

		view_listButton = new TempoUIListButton(getListX(edit_listButton), 'View');
		view_listButton.cameras = [camHUD];
		add(view_listButton);

		audio_listButton = new TempoUIListButton(getListX(view_listButton), 'Audio');
		audio_listButton.cameras = [camHUD];
		add(audio_listButton);

		tools_listButton = new TempoUIListButton(getListX(audio_listButton), 'Tools');
		tools_listButton.cameras = [camHUD];
		add(tools_listButton);

		help_listButton = new TempoUIListButton(getListX(tools_listButton), 'Help');
		help_listButton.cameras = [camHUD];
		add(help_listButton);

		file_listButton.others = [
			edit_listButton,
			view_listButton,
			audio_listButton,
			tools_listButton,
			help_listButton
		];
		edit_listButton.others = [
			file_listButton,
			view_listButton,
			audio_listButton,
			tools_listButton,
			help_listButton
		];

		view_listButton.others = [
			file_listButton,
			edit_listButton,
			audio_listButton,
			tools_listButton,
			help_listButton
		];
		audio_listButton.others = [
			file_listButton,
			edit_listButton,
			view_listButton,
			tools_listButton,
			help_listButton
		];
		tools_listButton.others = [
			file_listButton,
			edit_listButton,
			view_listButton,
			audio_listButton,
			help_listButton
		];
		help_listButton.others = [
			file_listButton,
			edit_listButton,
			view_listButton,
			audio_listButton,
			tools_listButton
		];
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
}
