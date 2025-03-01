#if !macro
// Engine
#if FEATURE_DISCORD_RPC
import engine.backend.api.DiscordClient;
#end
#if FEATURE_GAMEJOLT_CLIENT
import engine.backend.api.GameJoltClient;
#end
#if FEATURE_HSCRIPT_SCRIPTING
import tscript.TScript;
import tscript.backend.*;
import tscript.base.*;
#end
#if FEATURE_LUA_SCRIPTING
import llua.Lua;
import llua.LuaJIT;
import llua.State as LuaState;
import llua.Buffer as LuaBuffer;
import llua.Convert as LuaConvert;
import llua.LuaCallback;
import llua.LuaL;
import llua.LuaOpen;
#end
import engine.backend.Paths;
import engine.backend.util.MathUtil;
import engine.data.Save;
import engine.Constants;
#if tjson
import tjson.TJSON;
#end
// Sys
#if sys
import sys.io.File;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;
#end
// Funkin
import funkin.MusicBeatState;
import funkin.MusicBeatSubState;
// Haxe
import haxe.Json;
import haxe.Exception;
// Tempo
import tempo.TempoSprite;
import tempo.TempoInput;
import tempo.TempoState;
import tempo.TempoSubState;
import tempo.ui.*;
import tempo.util.TempoSave;
// OpenFL
import openfl.desktop.Icon;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.CairoRenderer;
import openfl.display.Stage;
import openfl.display3D.Context3D;
import openfl.errors.Error as OpenFLError;
import openfl.events.Event;
import openfl.filesystem.File as OpenFLFile;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.system.System;
import openfl.text.TextField;
import openfl.utils.Future;
import openfl.utils.Promise;
import openfl.utils.Timer;
import openfl.Assets as OpenFLAssets;
import openfl.Lib;
// Lime
import lime.app.Application;
import lime.app.Future as LimeFuture;
import lime.graphics.Image as LimeImage;
import lime.math.Rectangle as LimeRectangle;
import lime.media.AudioBuffer;
import lime.system.CFFI;
import lime.system.System as LimeSystem;
import lime.utils.Assets as LimeAssets;
// Flixel
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxAnimation;
import flixel.animation.FlxAnimationController;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
#if android
import flixel.input.android.FlxAndroidKey;
import flixel.input.android.FlxAndroidKeys;
import flixel.input.android.FlxAndroidKeyList;
#end
#if FEATURE_GAMEPAD_ALLOWED
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;
#end
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouse;
import flixel.input.touch.FlxTouch;
import flixel.input.FlxInput;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

using StringTools;
using Map;
using Lambda;
using engine.backend.util.tools.ArraySortTools;
using engine.backend.util.tools.ArrayTools;
using engine.backend.util.tools.FloatTools;
using engine.backend.util.tools.Int64Tools;
using engine.backend.util.tools.IntTools;
using engine.backend.util.tools.IteratorTools;
using engine.backend.util.tools.MapTools;
using engine.backend.util.tools.StringTools;
#end
