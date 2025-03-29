package engine.ui;

import engine.input.Cursor;
import tempo.ui.interfaces.ITempoUIState;

class EditorState extends MusicBeatState implements ITempoUIState
{
	public static var fromPlayState:Bool = false;
	public static var instance:EditorState = null;

	public var type:EditorType = UNKNOWN;

	public function new(type:EditorType = UNKNOWN)
	{
		super();

		if (type != null)
			this.type = type;
	}

	override function create():Void
	{
		instance = this;

		super.create();
	}

	override function update(e:Float):Void
	{
		super.update(e);

		if (!fromPlayState)
		{
			if (TempoInput.keyJustPressed.BACKSPACE)
				exit();
		}

		if (TempoInput.cursorJustPressed)
			playSound('ClickUp');
		else if (TempoInput.cursorJustReleased)
			playSound('ClickDown');
	}

	public function exit()
	{
		Tempo.stopMusic();
		Tempo.playSound(Paths.loader.sound(Paths.sound('cancelMenu.${Constants.EXT_SOUND}')));

		Cursor.hide();
		updateWindow(Constants.TITLE);
		TempoState.switchState(new funkin.ui.menus.MainMenuState());
	}

	/**
	 * Updating a application window
	 * @param title a text
	 * @param icon icon image (from 'engine/ui/')
	 * @param discordRPC ---
	 * -- 1st-details, 2nd-state, 3rd-largeImageKey, 4th-largeImageText, 5th-smallImageKey, 6th-smallImageText
	 */
	public function updateWindow(title:String, ?icon:String = null #if FEATURE_DISCORD_RPC, ?discordRPC:Array<String> = null #end)
	{
		if (title.startsWith('--C '))
			Lib.current.stage.application.window.title = Constants.TITLE + ' - ' + title.substr(3, title.length);
		else
			Lib.current.stage.application.window.title = title;

		if (icon != null)
		{
			if (FileSystem.exists('./assets/engine/ui/$icon.tsg'))
				Lib.current.stage.application.window.setIcon(lime.graphics.Image.fromFile('./assets/engine/ui/$icon.tsg'));
			else
				Lib.current.stage.application.window.setIcon(lime.graphics.Image.fromFile('./Resource/ico/x16.png'));
		}
		else
			Lib.current.stage.application.window.setIcon(lime.graphics.Image.fromFile('./Resource/ico/x16.png'));

		#if FEATURE_DISCORD_RPC
		if (discordRPC != null)
			DiscordClient.instance.changePresence({
				details: discordRPC[0],
				state: discordRPC[1],
				largeImageKey: discordRPC[2],
				largeImageText: discordRPC[3],
				smallImageKey: discordRPC[4],
				smallImageText: discordRPC[5]
			});
		#end
	}

	public function playSound(id:String):Void
	{
		if (id == null || id == "")
			return;

		Tempo.playSound(Paths.loader.sound(Paths.engine('audio/SFX/${id}.${Constants.EXT_SOUND}')));
	}

	public static function typeToString(type:EditorType):String
	{
		switch (type)
		{
			case CHART:
				return "Chart Editor";
			case NOTE:
				return "Note Editor";
			case ANIMATE:
				return "Animation Editor";
			case CHARACTER:
				return "Character Editor";
			case AUDIO:
				return "Audio Editor";
			case LEVEL:
				return "Level Editor";
			case STAGE:
				return "Stage Editor";
			case UNKNOWN:
				return "Unknown Editor";
		}

		return "N\\A";
	}

	public function getEvent(name:String, sender:tempo.ui.interfaces.ITempoUI) {}

	public function getFocus(value:Bool, thing:tempo.ui.interfaces.ITempoUI) {}
}

enum EditorType
{
	UNKNOWN;
	NOTE;
	CHARACTER;
	AUDIO;
	CHART;
	ANIMATE;
	LEVEL;
	STAGE;
}
