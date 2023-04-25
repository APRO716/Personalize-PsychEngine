package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import Achievements;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	#if ACHIEVEMENTS_ALLOWED
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Achievements Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		Achievements.loadAchievements();
		for (i in 0...Achievements.achievementsStuff.length) {
			if(!Achievements.achievementsStuff[i][3] || Achievements.achievementsMap.exists(Achievements.achievementsStuff[i][2])) {
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		for (i in 0...options.length) {
			var achieveName:String = Achievements.achievementsStuff[achievementIndex[i]][2];
			var optionText:Alphabet = new Alphabet(280, 300, Achievements.isAchievementUnlocked(achieveName) ? Achievements.achievementsStuff[achievementIndex[i]][0] : '?', false);
			optionText.isMenuItem = true;
			optionText.targetY = i - curSelected;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			var icon:AttachedAchievement = new AttachedAchievement(optionText.x - 105, optionText.y, achieveName);
			icon.sprTracker = optionText;
			achievementArray.push(icon);
			add(icon);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("font.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		changeSelection();

		super.create();
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float) {
		super.update(elapsed);

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (controls.UI_UP_P) {
			changeSelection(-shiftMult);
			holdTime = 0;
		}
		if (controls.UI_DOWN_P) {
			changeSelection(shiftMult);
			holdTime = 0;
		}
		if(controls.UI_DOWN || controls.UI_UP) {
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
		}
		if (FlxG.mouse.wheel != 0) {
			changeSelection(-FlxG.mouse.wheel);
		}
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		for (i in 0...achievementArray.length) {
			achievementArray[i].alpha = 0.6;
			if(i == curSelected) {
				achievementArray[i].alpha = 1;
			}
		}
		descText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][1];
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}
