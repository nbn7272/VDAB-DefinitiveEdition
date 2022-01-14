package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;

	private var player:Int;

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		/*var skin:String = 'NOTE_assets'; //why
		if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1 && player != 1)
			{
				skin = PlayState.SONG.arrowSkin;
			}
			else
			{
				skin = 'NOTE_assets';
			}

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + skin));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + skin), true, Math.floor(width), Math.floor(height));
			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);

			antialiasing = false;
			setGraphicSize(Std.int(width * ClientPrefs.noteSize * PlayState.daPixelZoom));

			switch (Math.abs(leData))
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		}
		else //WHY THE NOTE THINGS ARE HERE BRUH
		{
			babyArrow.frames = Paths.getSparrowAtlas(skin);
			babyArrow.antialiasing = ClientPrefs.globalAntialiasing;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.scales[_song.mania]));
			var dirName = Main.gfxDir[Main.gfxHud[_song.mania][i]];
			var pressName = Main.gfxLetterAlt[Main.gfxIndex[_song.mania][i]];
			babyArrow.animation.addByPrefix('static', 'arrow' + dirName);
			babyArrow.animation.addByPrefix('pressed', pressName + ' press', 24, false);
			babyArrow.animation.addByPrefix('confirm', pressName + ' confirm', 24, false);
			babyArrow.x += Note.swidths[mania] * Note.swagWidth * Math.abs(i);
		}

		updateHitbox();
		scrollFactor.set();
	}*/
	}

	public function postAddedToGroup() {
		playAnim('static');
		trace('SEX');
		/*x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;*/
	} //yes im stupid

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		
		/*if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
			updateConfirmOffset();
		}*/

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		offset.x = frameWidth / 2;
		offset.y = frameHeight / 2;

		offset.x -= 156 * Note.scales[PlayState.SONG.mania] / 2;
		offset.y -= 156 * Note.scales[PlayState.SONG.mania] / 2;

		/*if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				updateConfirmOffset();
			}
		}*/ //fuck
	}

	function updateConfirmOffset() { //TO DO: Find a calc to make the offset work fine on other angles
		//centerOffsets();
		//offset.x -= 13*(ClientPrefs.noteSize/0.7);
		//offset.y -= 13*(ClientPrefs.noteSize/0.7);
		
		//like wtf was this ^^^
		
		centerOrigin();
	}
}
