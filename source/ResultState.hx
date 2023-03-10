package;

import flixel.group.FlxGroup;
import Discord.DiscordClient;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

//"Static access to instance field (varible) is not allowed" mean you stupid go read kade version lol

using StringTools;

class ResultState extends MusicBeatState
{
    var rank:String = '${PlayState.instance.ratingName}';
    var FC:String = '${PlayState.instance.ratingFC}';
    var resultTxt:FlxText;
    var pressTxt:FlxText;
    var numscoregroup:FlxGroup = new FlxGroup();

    override function create()
    {
        DiscordClient.changePresence('Result Screen ${PlayState.SONG.song}', null);

        resultTxt = new FlxText(0, 12, FlxG.width, "", 6);
        resultTxt.scrollFactor.set();
		resultTxt.setFormat(Paths.font("font.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(resultTxt);

        pressTxt = new FlxText(15, FlxG.height - 44, 0, 'Press ENTER to Exit', 6);
        pressTxt.scrollFactor.set();
		pressTxt.setFormat(Paths.font("font.ttf"), 28, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(pressTxt);

        super.create();
    }

    override function update(elapsed:Float)
    {
        resultTxt.text = 'Song : ${PlayState.SONG.song}
        \nAccuracy = ${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%
        \nScore = ${PlayState.instance.songScore}
        \nMisses = ${PlayState.instance.songMisses}
        \nRank = ${rank} [${FC}]
        \nSicks = ${PlayState.instance.sicks}                         Goods = ${PlayState.instance.goods}
        \nBads = ${PlayState.instance.bads}                           Shits = ${PlayState.instance.shits}';

        if (controls.ACCEPT || FlxG.mouse.justPressed)
        {
            if (PlayState.isStoryMode){
                if(PlayState.storyPlaylist.length <= 0){
                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    MusicBeatState.switchState(new StoryMenuState());
                }else{
                    var difficulty:String = CoolUtil.getDifficultyFilePath();

                    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);

				    PlayState.cancelMusicFadeTween();
				    LoadingState.loadAndSwitchState(new PlayState());
                }
            }else{
                trace('WENT BACK TO FREEPLAY??');
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                MusicBeatState.switchState(new FreeplayState());
            }
        }

        super.update(elapsed);
    }
}