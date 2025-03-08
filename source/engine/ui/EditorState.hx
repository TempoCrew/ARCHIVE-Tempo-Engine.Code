package engine.ui;

import engine.input.Cursor;
import tempo.ui.interfaces.ITempoUIState;

class EditorState extends MusicBeatState implements ITempoUIState
{
	public static var fromPlayState:Bool = false;

	public var type:EditorType = UNKNOWN;

	public function new(type:EditorType = UNKNOWN)
	{
		super();

		if (type != null)
			this.type = type;
	}

	static var itsWillFullscreen:Bool = false;

	override function create():Void
	{
		super.create();

		if (FlxG.fullscreen)
		{
			itsWillFullscreen = true;
			FlxG.fullscreen = false;
		}

		TempoUI.cursor();
	}

	override function update(e:Float):Void
	{
		super.update(e);

		if (!fromPlayState)
		{
			if (TempoInput.keyJustPressed.BACKSPACE)
				exit();
		}

		if (type != null)
		{
			switch (type)
			{
				case(CHART | STAGE | ANIMATE | MENU):
					if (TempoInput.cursorJustPressed)
						FlxG.sound.play(Paths.loader.sound(Paths.engine('audio/SFX/ClickUp.ogg')));
					else if (TempoInput.cursorJustReleased)
						FlxG.sound.play(Paths.loader.sound(Paths.engine('audio/SFX/ClickDown.ogg')));
				default: // not lol
			}
		}
	}

	public function exit()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.play(Paths.loader.sound(Paths.sound('cancelMenu')));

		Cursor.hide();
		updateWindow(Constants.TITLE);
		TempoState.switchState(new funkin.ui.menus.TitleState(), () ->
		{
			if (itsWillFullscreen)
			{
				itsWillFullscreen = false;
				FlxG.fullscreen = true;
			}
		});
	}

	/**
	 * Updating a application window
	 * @param title a text
	 * @param icon icon image (from 'engine/materials/')
	 * @param discordRPC ---
	 * -- 1st-details, 2nd-state, 3rd-largeImageKey, 4th-largeImageText, 5th-smallImageKey, 6th-smallImageText
	 */
	public function updateWindow(title:String, ?icon:String = null #if FEATURE_DISCORD_RPC, ?discordRPC:Array<String> = null #end)
	{
		if (title.startsWith('--C '))
			Application.current.window.title = Constants.TITLE + ' - ' + title.substr(3, title.length);
		else
			Application.current.window.title = title;

		if (icon != null)
		{
			if (FileSystem.exists('./assets/engine/ui/$icon.tsg'))
				Application.current.window.setIcon(lime.graphics.Image.fromFile('./assets/engine/ui/$icon.tsg'));
			else
				Application.current.window.setIcon(lime.graphics.Image.fromFile('./Resource/logo/x16.png'));
		}
		else
			Application.current.window.setIcon(lime.graphics.Image.fromFile('./Resource/logo/x16.png'));

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

	public static function typeToString(type:EditorType):String
	{
		switch (type)
		{
			case CHART:
				return "Chart Editor";
			case ANIMATE:
				return "Animation Editor";
			case FREEPLAY:
				return "Freeplay Editor";
			case CHAR_SELECTOR:
				return "Character Select Editor";
			case MENU:
				return "Custom Menu Editor";
			case LEVEL:
				return "Level Editor";
			case STAGE:
				return "Stage Editor";
			case UNKNOWN:
				return "Unknown Editor";
		}
	}

	public function getEvent(name:String, sender:tempo.ui.interfaces.ITempoUI) {}

	public function getFocus(value:Bool, thing:tempo.ui.interfaces.ITempoUI) {}
}

enum EditorType
{
	UNKNOWN;
	CHART;
	ANIMATE;
	FREEPLAY;
	LEVEL;
	CHAR_SELECTOR;
	STAGE;
	MENU;
}
