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

		if ((FlxG.save.data.gjUser == null || FlxG.save.data.gjUser == "")
			&& (FlxG.save.data.gjToken == null || FlxG.save.data.gjToken == ""))
		{
			print('User data not exists!');
			return;
		}

		Api.userName = FlxG.save.data.gjUser;
		Api.userToken = FlxG.save.data.gjToken;
	}

	static var pingTimer:FlxTimer;

	var urlL:URLLoader;

	public function initialize(?printAllowed:Bool = true):Void
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

	public function login(name:String, token:String):Void
	{
		#if debug
		print('User - $name ($token)');
		#end

		Api.userName = name;
		Api.userToken = token;

		FlxG.save.data.gjUser = name;
		FlxG.save.data.gjToken = token;
		FlxG.save.flush();

		initialize(false);
	}

	public function logout():Void
	{
		if (Api.userName != "" && Api.userToken != "")
		{
			Api.userName = "";
			Api.userToken = "";

			FlxG.save.data.gjUser = null;
			FlxG.save.data.gjToken = null;
			FlxG.save.flush();

			if (FlxG.state != null)
			{
				FlxG.state.persistentUpdate = false;
				FlxG.state.openSubState(new RestartGameSubState("You want to restart game for ending Log Out?", () -> {
					#if cpp
					GJSystools.restart();
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
			trace('Completed! ($ID ${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! ($ID ${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! ($ID ${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! ($ID ${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! ($ID ${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! ($ID ${(res.scores == null ? "N/A" : Std.string(res.scores))} / ${res.rank == null ? 'N/A' : Std.string(res.rank)})');
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
			trace('Completed! ($ID ${(res.scores == null ? "N/A" : Std.string(res.scores))} / ${res.rank == null ? 'N/A' : Std.string(res.rank)})');
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
			trace('Completed! (${(res.message == null ? "N/A" : res.message)})');
		};
		daRequ.send();
	}

	public function fetchData(key:String, isPrivate:Bool = true):Void
	{
		var daRequ:Request = new Request(DATA_FETCH(key, isPrivate));
		daRequ.onProgress = constProgress;
		daRequ.onError = constErr;
		daRequ.onComplete = (res:Response) ->
		{
			trace('Completed! (${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! (${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! (${(res.message == null ? "N/A" : res.message)})');
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
			trace('Completed! (${(res.message == null ? "N/A" : res.message)})');
		};
		daRequ.send();
	}

	function checkUserData():Void
	{
		if (FlxG.save.data.gjUser == null || FlxG.save.data.gjUser == "")
			return;

		#if sys
		var avatRequest:Request = new Request(USER_FETCH(['${FlxG.save.data.gjUser}']));
		avatRequest.onComplete = (res:Response) ->
		{
			FileUtil.createTJSON('./Resource/gj_user.dat', res);

			if (getUser(res).avatar_url != null)
			{
				urlL = new URLLoader();
				urlL.dataFormat = BINARY;
				urlL.addEventListener(Event.COMPLETE, completedImage);
				if (getUser(res).avatar_url.startsWith('https://secure.gravatar.com/'))
				{
					urlL.load(new URLRequest('https://s.gjcdn.net/img/no-avatar-3.png'));

					#if debug
					trace('no-avatar-url');
					#end
				}
				else
				{
					urlL.load(new URLRequest(getUser(res).avatar_url));

					#if debug
					trace(getUser(res).avatar_url);
					#end
				}
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

	function completedImage(e:Event):Void
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
