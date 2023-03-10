package;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var storyWeek:Int = 0;

	public var scoreTxt:FlxText;
	public var tempScore:String = '';
	public var scoreSeparator:String = ' // ';
	public var camHUD:FlxCamera;

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		scoreTxt = new FlxText(0, (FlxG.height * 0.89) + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("font.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);
		scoreTxt.cameras = [camHUD];

		super.create();

		tempScore = 'Score: ${PlayState.instance.songScore}'; // Code From BeastlyGhost Again Lmao

		tempScore += scoreSeparator + 'Misses: ${PlayState.instance.songMisses}';
		tempScore += scoreSeparator + 'Accuracy: ${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%';
		tempScore += scoreSeparator + PlayState.instance.ratingName;
		tempScore += (PlayState.instance.ratingFC != null && PlayState.instance.ratingFC != '' ? ' [${PlayState.instance.ratingFC}]' : '');

		tempScore += '\n';

		scoreTxt.text = tempScore;
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriend = new Boyfriend(x, y, characterName);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.ACCEPT || FlxG.mouse.justPressed)
		{
			#if !switch
			if (!PlayState.instance.practiceMode && !PlayState.instance.cpuControlled) //Get Last Score Before You Died
				Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty, PlayState.instance.ratingPercent);
			#end
			if (PlayState.isStoryMode){
				if (!PlayState.instance.practiceMode && !PlayState.instance.cpuControlled)
					Highscore.saveWeekScore(WeekData.getWeekFileName(), PlayState.campaignScore, PlayState.storyDifficulty);
			}

			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.mouse.visible = true;
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			WeekData.loadTheFirstEnabledMod();
			#if !switch
			if (!PlayState.instance.practiceMode && !PlayState.instance.cpuControlled)
				Highscore.saveScore(PlayState.SONG.song, PlayState.instance.songScore, PlayState.storyDifficulty, PlayState.instance.ratingPercent);
			#end
			if (PlayState.isStoryMode){ //Get Last Score Before You Died
				MusicBeatState.switchState(new StoryMenuState());
				StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

				if (!PlayState.instance.practiceMode && !PlayState.instance.cpuControlled)
					Highscore.saveWeekScore(WeekData.getWeekFileName(), PlayState.campaignScore, PlayState.storyDifficulty);

				FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
				FlxG.save.flush();
			}else{
				MusicBeatState.switchState(new FreeplayState());
			}

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name == 'firstDeath')
		{
			if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}

			if (boyfriend.animation.curAnim.finished && !playingDeathSound)
			{
				if (PlayState.SONG.stage == 'tank')
				{
					playingDeathSound = true;
					coolStartDeath(0.2);
					
					var exclude:Array<Int> = [];

					FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
						if(!isEnding)
						{
							FlxG.sound.music.fadeIn(0.2, 1, 4);
						}
					});
				}
				else
				{
					coolStartDeath();
				}
				boyfriend.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}
