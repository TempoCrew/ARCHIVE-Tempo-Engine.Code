package engine.ui.debug;

import engine.ui.debug.helpers.FileHelper;
import engine.backend.Conductor;
import funkin.backend.song.MetaFile;
import funkin.backend.song.ChartFile;

class ChartEditorState extends EditorState
{
	public var song:{c:ChartFile, m:MetaFile} = null;

	public function new(_data_c:ChartFile, _data_m:MetaFile):Void
	{
		song = {c: (_data_c != null ? _data_c : null), m: (_data_m != null ? _data_m : null)};

		super(CHART);
	}

	override function create():Void
	{
		super.create();

		if (song == null)
			throw "So cool!";
		if (song.c == null)
			song.c = Constants.TEMPLATE_CHART;
		if (song.m == null)
			song.m = Constants.TEMPLATE_METADATA;

		generateMusic();
		Conductor.instance.bpm = song.m.bpm;

		updateWindow("--C Chart Editor", "icon-1", [
			"Chart Editor",
			"test",
			"chart-editor",
			"Chart Editor v0.1.0",
			"bf-pixel",
			"BF [PIXEL]"
		]);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	var voicesConflict:Map<String, Array<String>> = [];

	function generateMusic():Void
	{
		final curName:String = song.m.songName.toFolderCase();
		final curMeta:MetaFile = song.m;
		final curData:MetaPlayData = song.m.playData;

		var existsInst:Array<String> = [];
		var existsVoices:Array<String> = [];
		var existsEnemyVoices:Array<String> = [];

		// Instrumental
		if (FileHelper.songExists(curName, "Inst"))
			existsInst.push('Inst');

		// Voices of the void
		final bfTag:String = (curData.players.get('boyfriend') == null ? (curData.players.get('player') == null ? (curData.players.get('bf') == null ? "bf" : curData.players.get('bf')) : curData.players.get('player')) : curData.players.get('boyfriend'));
		final opponentTag:String = (curData.players.get('opponent') == null ? (curData.players.get('dad') == null ? (curData.players.get('enemy') == null ? "dad" : curData.players.get('enemy')) : curData.players.get('dad')) : curData.players.get('opponent'));

		final _ev:Bool = (FileHelper.songExists(curName, 'Voices.ogg'));
		final _evp:Bool = (FileHelper.songExists(curName, 'Voices-player.ogg'));
		final _evt:Bool = (FileHelper.songExists(curName, 'Voices-${bfTag}.ogg'));

		if (_ev && _evp && !_evt)
			voicesConflict.set("voices && player", ["Voices", "Voices-player"]);
		else if (!_ev && _evp && _evt)
			voicesConflict.set("player && " + bfTag.toFolderCase(), ["Voices-player", 'Voices-${bfTag}']);
		else if (_ev && !_evp && _evt)
			voicesConflict.set("voices && " + bfTag.toFolderCase(), ["Voices", "Voices-" + bfTag]);

		final notConflict:Bool = (!voicesConflict.exists("voices && player")
			&& !voicesConflict.exists("voices && " + bfTag.toFolderCase())
			&& !voicesConflict.exists("player && " + bfTag.toFolderCase()));
		if (notConflict)
		{
			if (_ev && !_evp && !_evt)
				existsVoices.push('Voices');
			else if (_evp && !_ev && !_evt)
				existsVoices.push('Voices-player');
			else if (_evt && !_ev && !_evp)
				existsVoices.push('Voices-${bfTag}');
		}

		for (i in 0...curData.difficulties.length)
		{
			final curDiff:String = curData.difficulties[i];

			if (FileHelper.songExists(curName, 'Inst-${curDiff}.ogg'))
				existsInst.push('Inst-${curDiff}');
			if (FileHelper.songExists(curName, 'Voices-${curDiff}.ogg'))
				existsVoices.push('Voices-${curDiff}');
		}
	}
}
