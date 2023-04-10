## [0.4.2] - Not much (10 April 2023)
- Toggleable Loading Screen
- Fixed can't hide FPS Option
- Optimize gameplay & Song when choosed
- Fix of 25 min music length cap CR https://github.com/ShadowMario/FNF-PsychEngine/pull/12226 Swag (D&B fan try to make 1 hour+ song be like)
- Better Changelog

## [0.4.1] - Yoooooo (6 April 2023)
- Fixed mouse still visible in StoryMode
- Result Screen won't show Song name anymore
- Rework Freeplay V2 : Optimize Ranking Letter & better diff space for score text
- Restart Song won't show Mouse anymore (Completely Fixed mouse visible)
- Delete Personalize Watermark at main menu & Colored Text (no name lol)
- Fixed Pause Menu null object when spam pause then null object
- Fixed Introtext show nothing
- Flash menu can use mouse to enter
- Fixed EditorPlayState null object reference when access it without pass PlayState (took 30 minutes to fix it :skull:)
- Improve EditorPlayState & when use downscroll the scoretxt & info now at top
- Fixed Press Reset Button BF doesn't ded

## [0.4] - SAY GEX Update[?] (16 Mar 2023)
- Easter Egg in TitleState now Completely Work
- EditorPlayState code base Completely Up to date with PlayState
- (GitHub) Workflow now with Exe only file when Action is finished
- DisplayedHealth now more Accurate when ded lol
- Restore Hot Dilf song that Removed in PE 0.5b (SAY GEX)
- Recolor Mainmenu Version Text to Pastel RGB uwu & Better Menu Tween
- Rework Freeplay Score Text (Add Letter Rank) & Cool Ass Tween (CR Hiro my homie https://github.com/hironothilo/)

## [0.3.3h] - Unexpected Update (13 Mar 2023)
- Little bit Improve Another Platform Support
- Change Mouse Visible = false to freeplay instead of PlayState
- Added more clientprefs var in FunkinLua for Lua Script
- Added parseJson for Lua (CR https://github.com/ShadowMario/FNF-PsychEngine/pull/12081)

## [0.3.3] - Epik (12 Mar 2023)
- Remove Custom Loading Screen Mod
- Fixed HScript not destroyed when done (for previous ver)
- Kind of more Optimize(?)
- More Info Result Screen
- Rewrite mouse code
- More Accurate Loss HP
- Kade Health System (Optional Disable by Default)
- default icon for credit state if icon not found or missing
- Basic Improvements to Lua's setHealthBarColors (CR https://github.com/ShadowMario/FNF-PsychEngine/pull/12074)
- Character Editor w mouse support (CR https://github.com/ShadowMario/FNF-PsychEngine/pull/8933) WOW

## [0.3.2] - Result Screen & more (7 Mar 2023)
- Result Screen WIP {Show Sick Good Bad Shit Hit , Score Misses Rank FC & Acc}
- GameOver Save the Score as Player Has OOF
- Loading Screen with Mod Folder Support (You can custom Loading Screen in Mod Folder now) Lol
- Update PE to e75b42f (Not Include Reworking Folder Organization)
- Autosave when pressing BACKSPACE to exit Chart Editor (CR EliteMasterEric)
- Character instances can be created anywhere, and bugs/crashes involving character assets can be prevented (CR https://github.com/ShadowMario/FNF-PsychEngine/pull/12029) Pretty Cool :D

## [Patch] - Lol (2 Mar 2023)
- Little bit more html5 support for FPS font
- REMOVE OPTIONS Shortcut in Pausemenu (Buggy) :(
- Imporve EditorPlayState Same like PlayState
- Little bit Improve Playbackrate CR https://github.com/Raltyro/FNF-PsikeEngine/ Epic :D

## [0.3.1] - IDK Man (1 Mar 2023)
- Actual Legacy Chart Support CR BeastlyGhost
- Memory Show Decimal & Improve FPS Code Base
- Delete unused Comment & Duplicate Code
- Fixed Playbackrate Timing Window
- Botplay Show Score now & Not Save Score :)
- Improve String
- add header.lua

## [0.3] - Kind of Big Ass (20 Feb 2023)
- Cleanup & Rewrite Many Code
- Fix Notesplash Null Object Reference when it null in ChartingState
- EditorPlayState use same PlayState Input System now
- Fixed Many Bug
- Add Mouse Support in Master Editor Menu
- Use Official Week 7 Update Song Files CR https://github.com/ShadowMario/FNF-PsychEngine/pull/11841
- Deleted Unused Files

## [0.2.3] - Many Thing (4 Feb 2023)
- In Title Menu Close Sound is Quieter
- Fix Mainmenu Mouse Scroll when accept it
- Week 7 NoteSplash
- Some Week 7 Code
- Show Combo sprite Option
- Fix Hurt note & Custom note Null Object Reference

## [0.2.2] - E (28 Jan 2023)
- Update PE to Experimental build
- Gamepad Support
- Mouse Support for Cutscene
- Fixed Many Code I Forgor :skull:
-use splice parameter in remove(); and remove splashes when they are killed CR https://github.com/ShadowMario/FNF-PsychEngine/pull/11752 BIG W

## [0.2.1h]
- Update PE to build 5d7a915
- Better README.MD
- **REMOVED SOFTCODED ACHIEVEMENT BECAUSE LUA MODCHART BROKEN :( SORRY**
- Increase FPS Cap to 600 FPS & Minimum FPS to 30 FPS
- Extendable Timing Window & lowest Timing Window for Sick is 5ms (Already have but more Extendable Lol)
I'm Bad At Coding Lol

## [0.2.1] - Shit Update (14 Jan 2023)
- Fixed Something in StrumNote.hx?
- Fixed some variable
- Fixed Code
- Deleted Unused Code
- New Better Hold Note System like [0.1.2] but It's Actually Better & Bug Fixed

## [0.2] - Many Inspiration Lol (8 Jan 2023)
- Flixel Save Files fix Credit : BeastlyGabi AKA BeastlyGhost [RESET GAME DATA!!!]
- Accuracy & Rank is Seperated in ScoreTxt
- Change Title to Normal Because Cringe
- Fixed Hold Note Length CR https://github.com/Raltyro/FNF-PsikeEngine
- Fixed Font weird in DialogueCharacterEditorState
- Softcoded Achievement CR https://github.com/ShadowMario/FNF-PsychEngine/pull/11651
- add mod folders to lua require paths https://github.com/ShadowMario/FNF-PsychEngine/pull/11489
- Ctrl+Mouse Click its go to the line when crash CR https://github.com/ShadowMario/FNF-PsychEngine/pull/11128
- Cool Thing https://github.com/ShadowMario/FNF-PsychEngine/pull/11456

## [0.1.3] - 2023 Update (2 Jan 2023)
- Update Psych Engine to Build d3e95b9
- Hold Note Animation Kind of Cleaner
- Remove hold before note appear because It's Dumb
- Optimize Some Code

## [0.1.2] - Before The Year 2022 End (31 Dec 2022)
- Kind of Smoother Health Bar
- Better Accuracy System (Previously Hold Note Doesn't Affect Accuracy)
- osu!mania Hold Note System (If Player hold their keys before note & long note appear It will disappear then count as miss , This prevent player cheat hold note to heal...) THIS REMOVED IN 0.1.3 because hold note late problem
- Somewhat Bug Fixes

## [0.1.1] - YEET (29 Dec 2022)
- Fixed Miss at last note before Song End Null Object Reference
- Better FreeplayState (Yellow Color When Selected Song && Icon Flicking)
- Playbackrate Effect Week 6 Intro Song...
- Recolor Game Icon
- Fix Lua Memory Leak - Credit https://github.com/ShadowMario/FNF-PsychEngine/pull/10740
- Optimize Some Code

## [0.1] - More Stable Update A.K.A Christmas Eve Update (24 Dec 2022)
- Update PE to Build e009694 (IDK Why I do this :V It's just change introtext Lmao)
- Fixed EditorPlayState Weird Input When Spam
- Completely Fixed Playbackrate Crash
- Cool Loading Screen
- Fixed Press ESC In TitleState Crash When not Initialized

## [0.0.1] - This is Just Start (17 Dec 2022)
- Psych Engine 0.6.3 Build 894bb38
- Better Icon Bop (Sacorg)
- Guitar Sustain (When Miss Sustain It will miss only 1)
- Combo Number Show Exact Digit instead of 3 digits
- Quick Option in PauseMenu
- Hold Note Doesn't affect Accuracy At All
- Pause Menu , Discord Show Current Playbackrate
- Full Mouse Support
- Press ESC in TitleState to Close Game (BeastlyGhost)