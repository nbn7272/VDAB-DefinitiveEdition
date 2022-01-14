package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;
	public static var ammo:Array<Int> = [4, 6, 9]; //had to reuse the 21 key code sorry
	public static var gfxIndex:Array<Dynamic> = [
		[3, 4, 5, 6],
		[3, 5, 6, 14, 4, 17],
		[3, 4, 5, 6, 7, 14, 15, 16, 17]
	];
	public static var gfxHud:Array<Dynamic> = [
		[1, 2, 3, 4],
		[1, 3, 4, 1, 2, 4],
		[1, 2, 3, 4, 5, 1, 2, 3, 4]
	];
	public static var gfxDir:Array<String> = ['SHARPLEFT', 'LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'PLUS', 'SHARPRIGHT'];
	public static var charDir:Array<String> = ['LEFT', 'LEFT', 'DOWN', 'UP', 'DOWN', 'RIGHT', 'UP', 'RIGHT', 'UP', 'LEFT', 'UP', 'RIGHT', 'DOWN'];
	public static var gfxLetter:Array<String> = ['mardi', 'deep', 'aqua', 'purple', 'blue', 'green', 'red', 'white', 'old', 'pink', 'lavender', 'orange', 'infra', 'blurple', 'yellow', 'violet', 'black', 'dark', 'gray', 'jonquil', 'shamrock'];
	public static var gfxLetterAlt:Array<String> = ['mardi', 'deep', 'aqua', 'left', 'down', 'up', 'right', 'white', 'old', 'pink', 'lavender', 'orange', 'infra', 'blurple', 'yel', 'violet', 'black', 'dark', 'gray', 'jonquil', 'shamrock'];
	//sorry vice and verwex
	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		Paths.getModFolders();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
