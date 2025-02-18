package engine.backend.api;

import engine.ui.RestartGameSubState;
#if FEATURE_GAMEJOLT_CLIENT
import engine.backend.util.FileUtil;
import engine.backend.macro.GameJoltMacro;
import gamejolt.formats.User;
import gamejolt.types.DataUpdateType;
import gamejolt.formats.Response;
import gamejolt.GameJolt as Api;
import gamejolt.GameJolt.GJRequest as Request;
import openfl.utils.ByteArray;

@:access(gamejolt.GameJolt)
#if (systools && cpp && FEATURE_GAMEJOLT_CLIENT)
@:access(engine.backend.api.GJSystools)
#end
@:access(engine.backend.macro.GameJoltMacro)
class GameJoltClient
{
	public static var instance(get, never):GameJoltClient;

	static var _instance:Null<GameJoltClient> = null;

	static var sessionOpened:Bool = false;
	static var sessionPinged:Bool = false;

	public var request:Request;

	private function new():Void
	{
		print("Initializing client...");

		Api.gameID = GameJoltMacro.getData().ID;
		Api.gameKey = GameJoltMacro.getData().Key;

		if ((Save.gjData.userName == null || Save.gjData.userName == "") && (Save.gjData.userToken == null || Save.gjData.userToken == ""))
		{
			print('User data not exists!');
			return;
		}

		Api.userName = Save.gjData.userName;
		Api.userToken = Save.gjData.userToken;
	}

	static var pingTimer:FlxTimer;

	var urlL:URLLoader;

	public function initialize(?printAllowed:Bool = true, ?onComplete:Response->Void):Void
	{
		if (Api.gameID != 0 && Api.gameKey != "")
		{
			if (printAllowed)
				print("Game ID and KEY exists!");

			if (Api.userName != "" && Api.userToken != "")
			{
				if (printAllowed)
					print("User data exists!");

				var initRequest:Request = new Request(SESSION_OPEN);
				initRequest.onError = constErr;
				initRequest.onComplete = (res:Response) ->
				{
					if (onComplete != null)
						onComplete(res);
					openSession();

					Lib.application.onExit.add((_) ->
					{
						stopSession();
					});
				};
				initRequest.send();
			}
		}
	}

	public function login(name:String, token:String, ?onComplete:Response->Void):Void
	{
		#if debug
		print('User - $name ($token)');
		#end

		Api.userName = name;
		Api.userToken = token;

		Save.gjData.userName = name;
		Save.gjData.userToken = token;
		Save.save(GAMEJOLT);

		initialize(false, onComplete);
	}

	public function logout():Void
	{
		if (Api.userName != "" && Api.userToken != "")
		{
			Api.userName = "";
			Api.userToken = "";

			Save.gjData.userName = null;
			Save.gjData.userToken = null;
			Save.save(GAMEJOLT);

			if (FlxG.state != null)
			{
				FlxG.state.persistentUpdate = false;
				FlxG.state.openSubState(new RestartGameSubState("You want to restart game for ending Log Out?", () -> {
					#if cpp
					new GJSystools();
					#else
					System.exit(1337);
					#end
				}));
			}
		}
	}

	public function pingSession(request:Request):Void
	{
		if (request == null)
			return;

		sessionPinged = true;

		request.call = SESSION_PING(true);
		request.send();

		print('Ping!');
	}

	public function openSession():Void
	{
		if (pingTimer != null)
			pingTimer.cancel();

		sessionOpened = true;
		sessionPinged = false;

		print('Session opened!');

		checkUserData();
	}

	public function stopSession():Void
	{
		if (sessionOpened && !sessionPinged)
		{
			print("Session Closed!");

			if (pingTimer != null)
				pingTimer.cancel();

			var stopReq:Request = new Request(SESSION_CLOSE);
			stopReq.send();
		}
	}

	public function setTrophy(ID:Int):Void
	{
		var trRequest:Request = new Request(TROPHIES_ADD(ID));
		trRequest.onProgress = constProgress;
		trRequest.onError = constErr;
		trRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		trRequest.send();
	}

	public function fetchTrophy(Achieved:Bool = false, ID:Int):Void
	{
		var trRequest:Request = new Request(TROPHIES_FETCH(Achieved, ID));
		trRequest.onProgress = constProgress;
		trRequest.onError = constErr;
		trRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		trRequest.send();
	}

	public function removeTrophy(ID:Int):Void
	{
		var trRequest:Request = new Request(TROPHIES_REMOVE(ID));
		trRequest.onProgress = constProgress;
		trRequest.onError = constErr;
		trRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		trRequest.send();
	}

	public function setScore(score:String, ID:Int):Void
	{
		var scRequest:Request = new Request(SCORES_ADD(score, 1, null, ID));
		scRequest.onProgress = constProgress;
		scRequest.onError = constErr;
		scRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		scRequest.send();
	}

	public function fetchScore(limit:Int, ID:Int, betterThan:Int):Void
	{
		var scRequest:Request = new Request(SCORES_FETCH(true, ID, limit, betterThan));
		scRequest.onProgress = constProgress;
		scRequest.onError = constErr;
		scRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		scRequest.send();
	}

	public function getScore(ID:Int):Int
	{
		var scRequest:Request = new Request(SCORES_GETRANK(1, ID));
		scRequest.onProgress = constProgress;
		scRequest.onError = constErr;
		scRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		scRequest.send();

		return 0;
	}

	public function getScoreTable(ID:Int)
	{
		var scRequest:Request = new Request(SCORES_TABLES);
		scRequest.onProgress = constProgress;
		scRequest.onError = constErr;
		scRequest.onComplete = (res:Response) ->
		{
			trace('Completed! ($ID ${Std.string(res)})');
		};
		scRequest.send();
	}

	public function setData(key:String, data:String, isPrivate:Bool = true):Void
	{
		var daRequ:Request = new Request(DATA_SET(key, data, isPrivate));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			trace('Completed! (${Std.string(res)})');
		};
		daRequ.send();
	}

	var _lastData:String;

	public function fetchData(key:String, isPrivate:Bool = true, ?onComplete:Response->Void):Void
	{
		var daRequ:Request = new Request(DATA_FETCH(key, isPrivate));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			onComplete(res);
			trace('Completed! (${Std.string(res)})');
		};
		daRequ.send();
	}

	public function getKeysData(isPrivate:Bool = true, ?pattern:Null<String>):Void
	{
		var daRequ:Request = new Request(DATA_GETKEYS(isPrivate, pattern));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			var jsonD:Array<Dynamic> = [];
			for (i in 0...res.keys.length)
			{
				fetchData(res.keys[i].key, isPrivate, (res2:Response) ->
				{
					jsonD.push({key: res.keys[i].key, data: res2.data});
				});
			}

			FileUtil.createTJSON('./Resource/gj_cloud.dat', {cloud: jsonD});
			trace('Completed! (${Std.string(jsonD)})');
		};
		daRequ.send();
	}

	public function removeData(key:String, isPrivate:Bool = true):Void
	{
		var daRequ:Request = new Request(DATA_REMOVE(key, isPrivate));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			trace('Completed! (${Std.string(res)})');
		};
		daRequ.send();
	}

	public function updateData(key:String, operation:DataUpdateType, isPrivate:Bool = true):Void
	{
		var daRequ:Request = new Request(DATA_UPDATE(key, operation, isPrivate));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			trace('Completed! (${Std.string(res)})');
		};
		daRequ.send();
	}

	function checkUserData():Void
	{
		if (Save.gjData.userName == null || Save.gjData.userName == "")
			return;

		#if sys
		var avatRequest:Request = new Request(USER_FETCH(['${Save.gjData.userName}']));
		avatRequest.onComplete = (res:Response) ->
		{
			FileUtil.createTJSON('./Resource/gj_user.dat', res);

			print("Connected! User - " + getUser(res).username + " [" + getUser(res).id + "]");

			getKeysData();

			if (getUser(res).avatar_url != null)
			{
				urlL = new URLLoader();
				urlL.dataFormat = BINARY;
				urlL.addEventListener(Event.COMPLETE, onCompleteImage);
				if (getUser(res).avatar_url.startsWith('https://secure.gravatar.com/'))
					urlL.load(new URLRequest('https://s.gjcdn.net/img/no-avatar-3.png'));
				else
					urlL.load(new URLRequest(getUser(res).avatar_url));

				print("User Avatar Exists!");
			}
		};
		avatRequest.send();
		#end
	}

	function getUser(res:Response):User
	{
		if (res != null && res.users != null && res.users[0] != null)
			return res.users[0];

		return null;
	}

	function constProgress(fe:Float, tt:Float):Void
		print("Progress: " + fe + ' / ' + tt);

	function constErr(msg:String):Void
	{
		if (pingTimer != null)
			pingTimer.cancel();

		print('ERROR: ' + msg);
	}

	function onCompleteImage(e:Event):Void
	{
		var byteA:ByteArray;
		if ((urlL.data is ByteArrayData))
			byteA = urlL.data;
		else
		{
			byteA = new ByteArray();
			byteA.writeUTFBytes(Std.string(urlL.data));
		}

		FileUtil.writeBytesToPath('./Resource/gj_user.png', byteA, Force);
	}

	static function print(data:String)
	{
		#if sys
		Sys.println('GameJolt Client: $data');
		#else
		trace('GameJolt Client: $data');
		#end
	}

	static function get_instance():GameJoltClient
	{
		if (GameJoltClient._instance == null)
			_instance = new GameJoltClient();
		if (GameJoltClient._instance == null)
			throw "Could not initialize singleton GameJoltClient!";
		return GameJoltClient._instance;
	}
}
#end
