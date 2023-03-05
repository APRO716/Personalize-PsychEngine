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
    var score:Int = 0;
    var misses:Int = 0;
    var rank:String = "";
    var FC:String = "";
    var accuracytxt:FlxText;
    var sicknum:Int = 0;
    var goodnum:Int = 0;
    var badnum:Int = 0;
    var shitnum:Int = 0;
    var numscoregroup:FlxGroup = new FlxGroup();

    override function create()
    {
        rank = PlayState.instance.ratingName;
        FC = PlayState.instance.ratingFC;

        DiscordClient.changePresence('Result Screen ${PlayState.SONG.song}', null);

        accuracytxt = new FlxText(0, 12, FlxG.width, "", 6);
        accuracytxt.scrollFactor.set();
		accuracytxt.setFormat(Paths.font("font.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(accuracytxt);
        super.create();
    }

    override function update(elapsed:Float)
    {
        score =  Math.ceil(FlxMath.lerp(score, PlayState.instance.songScore, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        misses =  Math.ceil(FlxMath.lerp(misses, PlayState.instance.songMisses, CoolUtil.boundTo(elapsed * 48,0, 1)));
        sicknum = Math.ceil(FlxMath.lerp(sicknum, PlayState.instance.sicks, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        goodnum = Math.ceil(FlxMath.lerp(goodnum, PlayState.instance.goods, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        badnum = Math.ceil(FlxMath.lerp(badnum, PlayState.instance.bads, CoolUtil.boundTo(elapsed * 48, 0, 1)));
        shitnum = Math.ceil(FlxMath.lerp(shitnum, PlayState.instance.shits, CoolUtil.boundTo(elapsed * 48, 0, 1)));

        accuracytxt.text = 'Accuracy = ${Highscore.floorDecimal(PlayState.instance.ratingPercent * 100, 2)} %
        \nScore = ${score}
        \nMisses = ${misses}
        \nRank = ${rank} [${FC}]
        \nSicks = ${sicknum}                         Goods = ${goodnum}
        \nBads = ${badnum}                           Shits = ${shitnum}';

        if (controls.ACCEPT)
        {
            playConfirmSound(); // Prevent Earrrape Sound
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
    }

    public static function playConfirmSound() {
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.8);
    }
}