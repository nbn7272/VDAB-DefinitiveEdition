package;

import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flash.display.BitmapData;
import editors.ChartingState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	//public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var hitByOpponent:Bool = false;
	public var noteWasHit:Bool = false;
	public var prevNote:Note;
	public var LocalScrollSpeed:Float = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType(default, set):String = null;

	public var eventName:String = '';
	public var eventVal1:String = '';
	public var eventVal2:String = '';

	public var colorSwap:ColorSwap;
	public var inEditor:Bool = false;
	private var earlyHitMult:Float = 0.5;

	public static var scales:Array<Float> = [0.7, 0.6, 0.55, 0.46];
	public static var swidths:Array<Float> = [160, 120, 110, 90];
	public static var posRest:Array<Int> = [0, 35, 50, 70];

	public static var swagWidth:Float = 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;
	public var MyStrum:FlxSprite;
	private var InPlayState:Bool = false;

	// Lua shit
	public var noteSplashDisabled:Bool = false;
	public var noteSplashTexture:String = null;
	public var noteSplashHue:Float = 0;
	public var noteSplashSat:Float = 0;
	public var noteSplashBrt:Float = 0;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;

	public var copyX:Bool = true;
	public var copyY:Bool = true;
	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;

	public var hitHealth:Float = 0.023;
	public var missHealth:Float = 0.0475;

	public var texture(default, set):String = null;

	public var noAnimation:Bool = false;
	public var hitCausesMiss:Bool = false;

	private function set_texture(value:String):String {
		if(texture != value) {
			reloadNote('', value);
		}
		texture = value;
		return value;
	}

	private function set_noteType(value:String):String {
		noteSplashTexture = PlayState.SONG.splashSkin;
		/*
		colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
		colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
		colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;*/

		if(noteData > -1 && noteType != value) {
			switch(value) {
				case 'Hurt Note':
					ignoreNote = mustPress;
					reloadNote('HURT');
					noteSplashTexture = 'HURTnoteSplashes';
					/*colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;*/
					if(isSustainNote) {
						missHealth = 0.1;
					} else {
						missHealth = 0.3;
					}
					hitCausesMiss = true;
				case 'No Animation':
					noAnimation = true;
			}
			noteType = value;
		}
		/*noteSplashHue = colorSwap.hue;
		noteSplashSat = colorSwap.saturation;
		noteSplashBrt = colorSwap.brightness;*/
		return value;
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false, ?isPlayer:Bool = false)
	{
		super();
		var mania = PlayState.SONG.mania;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.inEditor = inEditor;

		x += (ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X) + 50 - posRest[mania];
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;
		if(!inEditor) this.strumTime += ClientPrefs.noteOffset;

		this.noteData = noteData;

		if(noteData > -1) {
			texture = '';
			/*colorSwap = new ColorSwap();
			shader = colorSwap.shader;*/

			x += swidths[mania] * swagWidth * (noteData % Main.ammo[mania]);
			if(!isSustainNote) { //Doing this 'if' check to fix the warnings on Senpai songs
				animation.play(Main.gfxLetter[Main.gfxIndex[mania][noteData]]);
			}
		}

		if(isPlayer) texture = 'NOTE_assets';
		// trace(prevNote);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating':
			if (mania == 0) {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 3;
						notetolookfor = 3;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('redScroll');
				}
			}
			else if (mania == 1) {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 5;
						notetolookfor = 5;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 3;
						notetolookfor = 3;
						animation.play('greenScroll');
					case 2:
						notetolookfor = 1;
						x += swagWidth * 1;
						animation.play('redScroll');
					case 3:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('yellowScroll');
					case 4:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('blueScroll');
					case 5:
						x += swagWidth * 4;
						notetolookfor = 4;
						animation.play('darkScroll');
				}
			}
			else {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 5;
						notetolookfor = 5;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 7;
						notetolookfor = 7;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 3;
						x += swagWidth * 3;
						animation.play('redScroll');
					case 4:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('whiteScroll');
					case 5:
						x += swagWidth * 2;
						notetolookfor = 2;
						animation.play('yellowScroll');
					case 6:
						x += swagWidth * 8;
						notetolookfor = 8;
						animation.play('violetScroll');
					case 7:
						x += swagWidth * 6;
						notetolookfor = 6;
						animation.play('blackScroll');
					case 8:
						notetolookfor = 4;
						x += swagWidth * 4;
						animation.play('darkScroll');
				}
			}
				flipY = (Math.round(Math.random()) == 0); //fuck you
				flipX = (Math.round(Math.random()) == 1);

			default:
				if (mania == 0) {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 2;
						notetolookfor = 2;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 3;
						x += swagWidth * 3;
						animation.play('redScroll');
				}
			}
			else if (mania == 1) {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('greenScroll');
					case 2:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('redScroll');
					case 3:
						notetolookfor = 3;
						x += swagWidth * 3;
						animation.play('yellowScroll');
					case 4:
						x += swagWidth * 4;
						notetolookfor = 4;
						animation.play('blueScroll');
					case 5:
						x += swagWidth * 5;
						notetolookfor = 5;
						animation.play('darkScroll');
				}
			}
			else {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 2;
						notetolookfor = 2;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 3;
						x += swagWidth * 3;
						animation.play('redScroll');
					case 4:
						x += swagWidth * 4;
						notetolookfor = 4;
						animation.play('whiteScroll');
					case 5:
						x += swagWidth * 5;
						notetolookfor = 5;
						animation.play('yellowScroll');
					case 6:
						x += swagWidth * 6;
						notetolookfor = 6;
						animation.play('violetScroll');
					case 7:
						x += swagWidth * 7;
						notetolookfor = 7;
						animation.play('blackScroll');
					case 8:
						notetolookfor = 8;
						x += swagWidth * 8;
						animation.play('darkScroll');
				}
			}
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating' | 'unfairness':
				if (Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState"))
				{
					var state:PlayState = cast(FlxG.state,PlayState);
					InPlayState = true;
					if (mustPress)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.opponentStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
									x = spr.x;
									MyStrum = spr;
								}
							});
					}
				}
		}
		if (PlayState.SONG.song.toLowerCase() == 'unfairness')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0,120) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1,3);
			}
		}

		
		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			multAlpha = 0.6;
			if(ClientPrefs.downScroll) flipY = true;

			offsetX += width / 2;
			copyAngle = false;

			animation.play(Main.gfxLetter[Main.gfxIndex[mania][noteData]] + ' hold end');

			updateHitbox();

			offsetX -= width / 2;

			if (PlayState.isPixelStage)
				offsetX += 30;

			if (prevNote.isSustainNote)
				{
					prevNote.animation.play(Main.gfxLetter[Main.gfxIndex[mania][noteData]] + ' hold piece');
	
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.05 * PlayState.SONG.speed;
					if(PlayState.isPixelStage) {
						prevNote.scale.y *= 1.19;
					}
					prevNote.updateHitbox();
					// prevNote.setGraphicSize();
				}

			if(PlayState.isPixelStage) {
				scale.y *= PlayState.daPixelZoom;
				updateHitbox();
			}
		} else if(!isSustainNote) {
			earlyHitMult = 1;
		}
		x += offsetX;
	}

	function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '') {
		if(prefix == null) prefix = '';
		if(texture == null) texture = '';
		if(suffix == null) suffix = '';
		
		var skin:String = texture;
		if(texture.length < 1) {
			skin = PlayState.SONG.arrowSkin;
			if(skin == null || skin.length < 1) {
				skin = 'NOTE_assets';
			}
		}

		var animName:String = null;
		if(animation.curAnim != null) {
			animName = animation.curAnim.name;
		}

		var arraySkin:Array<String> = skin.split('/');
		arraySkin[arraySkin.length-1] = prefix + arraySkin[arraySkin.length-1] + suffix;

		var lastScaleY:Float = scale.y;
		var blahblah:String = arraySkin.join('/');
		if(PlayState.isPixelStage) {
			if(isSustainNote) {
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'));
				width = width / 4;
				height = height / 2;
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'), true, Math.floor(width), Math.floor(height));
			} else {
				loadGraphic(Paths.image('pixelUI/' + blahblah));
				width = width / 4;
				height = height / 5;
				loadGraphic(Paths.image('pixelUI/' + blahblah), true, Math.floor(width), Math.floor(height));
			}
			setGraphicSize(Std.int(width * ClientPrefs.noteSize * PlayState.daPixelZoom));
			loadPixelNoteAnims();
			antialiasing = false;
		} else {
			frames = Paths.getSparrowAtlas(blahblah);
			loadNoteAnims();
			antialiasing = ClientPrefs.globalAntialiasing;
		}
		if(isSustainNote) {
			scale.y = lastScaleY;
		}
		updateHitbox();

		if(animName != null)
			animation.play(animName, true);

		if(inEditor) {
			setGraphicSize(ChartingState.GRID_SIZE, ChartingState.GRID_SIZE);
			updateHitbox();
		}
	}

	function loadNoteAnims() {
		for (i in 0...21)
		{
			animation.addByPrefix(Main.gfxLetter[i], Main.gfxLetter[i] + '0');

			if (isSustainNote)
			{
				animation.addByPrefix(Main.gfxLetter[i] + ' hold piece', Main.gfxLetter[i] + ' hold piece');
				animation.addByPrefix(Main.gfxLetter[i] + ' hold end', Main.gfxLetter[i] + ' hold end');
			}
		}
		
		setGraphicSize(Std.int(width * scales[PlayState.SONG.mania]));
		updateHitbox();
	}

	function loadPixelNoteAnims() {
		if(isSustainNote) {
			animation.add('purpleholdend', [PURP_NOTE + 4]);
			animation.add('greenholdend', [GREEN_NOTE + 4]);
			animation.add('redholdend', [RED_NOTE + 4]);
			animation.add('blueholdend', [BLUE_NOTE + 4]);

			animation.add('purplehold', [PURP_NOTE]);
			animation.add('greenhold', [GREEN_NOTE]);
			animation.add('redhold', [RED_NOTE]);
			animation.add('bluehold', [BLUE_NOTE]);
		} else {
			animation.add('greenScroll', [GREEN_NOTE + 4]);
			animation.add('redScroll', [RED_NOTE + 4]);
			animation.add('blueScroll', [BLUE_NOTE + 4]);
			animation.add('purpleScroll', [PURP_NOTE + 4]);
		}
	}

	//public var isAlt:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		
		if (MyStrum != null)
		{
			x = MyStrum.x + (isSustainNote ? width : 0);
		}
		else
		{
			if (InPlayState)
			{
				var state:PlayState = cast(FlxG.state,PlayState);
				if (mustPress)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.opponentStrums.forEach(function(spr:FlxSprite)
							{
								if (spr.ID == notetolookfor)
								{
									x = spr.x;
									MyStrum = spr;
								}
							});
					}
			}
		}
		if (mustPress)
		{
			// ok river
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}