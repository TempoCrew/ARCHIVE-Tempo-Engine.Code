package funkin.data;

import haxe.Http;

class Update
{
	public static var userMustUpdate:Bool = false;
	public static var newUpdate:String = '';

	public static function check():Void
	{
		trace('Checking a git-update...');

		var http:Http = new Http("https://raw.githubusercontent.com/MrzkTeam/FNF-TempoEngine/refs/heads/main/.version?token=GHSAT0AAAAAACZT33IFXZGODETV7JWDW3MUZZLNIMQ");
		http.onData = (d:String) ->
		{
			if (d.contains("404: Not Found"))
			{
				trace('Error 404!');
				return;
			}

			newUpdate = d.split('\n')[0].trim();
			var curVers = lime.app.Application.current.meta.get('version');
			trace('New version: $newUpdate');
			if (newUpdate != curVers)
			{
				trace('NEW UPDATE!!');
				userMustUpdate = true;
			}
		}

		http.onError = (e) -> trace(e);

		http.request();
	}
}
