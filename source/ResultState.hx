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

//"Static access to instance field (varible) is not allowed" mean you stupid go read kade version lol -hiro not hilo

using StringTools;

class ResultState extends MusicBeatState
{
    var rank:String = PlayState.instance.ratingName;
    var FC:String = PlayState.instance.ratingFC;
    var resultTxt:FlxText;
    var pressTxt:FlxText;

    override function create()
    {
        DiscordClient.changePresence('Result Screen', null);

        resultTxt = new FlxText(0, 12, FlxG.width, "", 6);
        resultTxt.scrollFactor.set();
		resultTxt.setFormat(Paths.font("font.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(resultTxt);

        pressTxt = new FlxText(15, FlxG.height - 44, 0, '', 6);
        pressTxt.scrollFactor.set();
		pressTxt.setFormat(Paths.font("font.ttf"), 28, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(pressTxt);

        resultTxt.text = 'Song Cleared!
        \nScore : ${PlayState.instance.songScore}
        \nAccuracy : ${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)}%
        \nMisses : ${PlayState.instance.songMisses}
        \nRank : ${rank} [${FC}]
        \nSicks = ${PlayState.instance.sicks}                        Goods = ${PlayState.instance.goods}
        \nBads = ${PlayState.instance.bads}                           Shits = ${PlayState.instance.shits}';

        pressTxt.text = (!PlayState.isStoryMode || PlayState.storyPlaylist.length <= 0) ? 'Press ENTER to Exit' : 'Press ENTER to Play Next Song';

        super.create();
    }

    function destroyText()
    {
        resultTxt.destroy();
        pressTxt.destroy();
    }

    override function update(elapsed:Float)
    {
        if (controls.ACCEPT || FlxG.mouse.justPressed)
        {
            destroyText();
            if (PlayState.isStoryMode){
                if(PlayState.storyPlaylist.length <= 0){
                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    MusicBeatState.switchState(new StoryMenuState());
                }else{
                    FlxG.mouse.visible = false;

                    var difficulty:String = CoolUtil.getDifficultyFilePath();
                    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);

				    PlayState.cancelMusicFadeTween();
				    LoadingState.loadAndSwitchState(new PlayState());
                }
            }else{
                trace('WENT BACK TO FREEPLAY??');
                MusicBeatState.switchState(new FreeplayState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }
        }

        super.update(elapsed);
    }
}