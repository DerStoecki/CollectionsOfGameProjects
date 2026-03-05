# CollectionsOfGameProjects


## Description

In this Repo I want to provide my personal Projects from my GameDev journey.
Primarily GODOT. Even though I am still at the beginning of this path,
sharing the code might help one of you in the future.

## About Me

<p>Hi I'm Felix, aka @DerStoecki. </p>
<p>I started my (gamedev) journey all the way back in 2017, with some brackeys tutorials,
gamdev.tv or even udemy, but tbh that was also the beginning of my whole programming journey
and I didn't understood a thing and just "did" the tutorials without understanding a thing.
Not only coding, but the engines (UE and Unity) are overwhelming.</p>
<p>But this changed, when I started studying applied Computer Science (B.Sc) back in 2017.
Through the years I "understood" programming, I "got it" so to speak.
I understood how to code, how to think like a programmer etc.
But I "forgot" about my hobby GameDevelopment ... well simply bc of life. But this gradually changes, since I am integrating this hobby more and more into my life.
</p>

<p>Since 2021 I am working fulltime as a JavaDev, started a part-time job in 2019/2020 and studied applied Computer Science
from 2017-2021 successfully. <br>During this time I learned a lot about programming and software architecture.
<p>So now I am at the real beginning of my GameDev-Journey.

I want to share with you my progress/learnings/code.

## Gameslist

<b>Disclaimer:</b>
I am only providing code, and not the assets.
I only put original games/gameideas here and no courses/tutorials I did or do bc of obv. reasons.

Abandoned Projects and ideas are ofc. listed, but may be written in earlier versions of godot.

You can use/get inspired by my code, feel free to either copy classes, or code snippets, just don't blatantly copy everything.
If you mention me in your (SFW) projects (Tag my Github or smth.) I'd be happy, but you don't have to.

Current List of personal projects and their states

1. ISeeYou (done)
1. ToastJump (done)
1. SweetMotherOfMine (barely started - archived)
1. NecromancerDefense (abandoned)
1. Kuhlifumdenteich (abandoned)


Zenva courses unordered list and not accurately named (basically humble bundle course bundles and I started/finished a few of them):

- Hello World projects
- mini projects series
- zenva cozy game series
- jump n run 2d and 3d
- turn based rpg
- farming rpg

## ISeeYou

<p> I see you is my first "real" game, designed and implemented within a timespan of 3 months. After my working hours</p>
<p>It is a soft horror jump'n'run mini adventure game.<br>
Est. Playtime: 15 min.<br>
You are a "Lost Place" hunter/Investigator, finding an old mansion.<br>
You heard there are ghosts hunting living souls, since a failed ritual.<br>
You arrive at the mansion at night and try to solve the mystery about that mansion.<br>
Your only companion is your flashlight, holding the ghosts at bay and try to find the lost totems to end the ritual and free the spirits</p>
<p> I learned a lot through this project and know what to do better. But I am very proud for what i did within those 3 months.
I started with a GameDesignDocument (GDD), started to create a placeholder main character pixel sprite (and ofc it stayed until the end...due to missing time)
<br>
Here are some images

### StartScreen and StartMenu

I wanted to make the startscreen somewhat interactive. You can click on certain parts of the main characters jacket to trigger animations instead of plain "buttons". You can start your journey, leave, open options, or click on his notepad to get a "tutorial". I sadly hadn't the time to create an interactive tutorial.

<img src="/showcase/iseeyou/startscreen.png" alt="Start Screen" width = 300><img src="/showcase/iseeyou/NewGame.png" alt="Start Menu" width = 300>

### In the mansion

<img src="/showcase/iseeyou/beginning.png" alt="Showing the start position in the mansion" width = 300><img src="/showcase/iseeyou/Flashlight.png" alt="Showing your weapon of choice...the flashlight" width = 300>


### Finding a totem

<img src="/showcase/iseeyou/findingtotem.png" alt="Finding a totem, but flashlight is needed" width = 300><img src="/showcase/iseeyou/findingtotem2.png" alt="Showcase: Flashlight is lighting up hidden totems" width = 300>


#### Ghosts


Ghosts are the hidden enemies but can be heart since they are increasing your heartbeat (somewhat like dbd SoundDesign when the killer is nearby)
Can be slowed down by your flashlight.
They start hunting you once you gathered your first Totem

#### learnings

- Scene changes
- path2D and navigation layer
- For future: auto tile system and physics are already keeping delta time in mind (didn't know that back then)
- Basic shaders
- how to write a GDD and how it helps with structure, planning and keep the scope of a game
- Sound BUS system and affecting some SFX
- randomizing footstep sounds depending on the "floor" type connected to the tiles
- how to write options, credits, and transitions
- How it feels to complete a real project with a real start and end.
- Why it is so important to make mikro and minigames first before starting a big project
- pixelart and asset creation in general takes a lot of time and energy but also very satisfying

## ToastJump

<p>This micro Arcade Game was created during Christmastime...I believe it was the year 2024.... within a Timespan of 3 days, where I wanted to show my little Sister what can be done within a few days of game dev.</p>

It's a basic Arcade game where you play as a goofy little toast trying to catch peanutbutter and jelly to score points.
Try to avoid Tuna and Poison, while also evading various kitchen clutter and a roomba.

This is a simple 1 Scene game

### Start

<img src="/showcase/toastjump/startscreen.png" alt="Start Screen of the game" width = 300>

### Aim

This game should feel chaotic but fun, with a lot going on.
Evade the roomba and clutter, evade the tuna and poison, collect peanutbutter and jelly, collect hearts and butter.
Collecting butter increases your multiplier.

I also implemented a sprint and doublejump mechanic.

To prevent instant overwhelm, I started with some timers. The player has time to collect some "good" collectibles, and the game gets harder over time by spawning more and more dangerous items.

<img src="/showcase/toastjump/toastjump.png" alt="Some Game Footage" width = 300>
<img src="/showcase/toastjump/toastjump2.png" alt="Some Game Footage" width = 300><br>
<img src="/showcase/toastjump/toastjump3.png" alt="Some Game Footage" width = 300>
<img src="/showcase/toastjump/toastjump4.png" alt="Some Game Footage" width = 300><br>
<img src="/showcase/toastjump/toastjump5.png" alt="Some Game Footage" width = 300>


### Game over

When you loose all your hearts, you can set your score and save it, arcade style with 3 letters.
Note: The moment you loose all your hearts, the scene gets paused, which can cause hilarious images of toasty.

<img src="/showcase/toastjump/gameover.png" alt="Some Game Footage" width = 300>


#### learnings

- You can create a fun experience within a few days and simple mechanics
- even abandoned / postponed projects help a lot and the learnings of the past help you improve your speed immensly
- You do not need complicated mechanics to bring joy to the player
- Like seriously my whole family tried this game and had fun and laughed a lot
- Fun and simplicity is the most important thing in the beginning


## SweetMotherOfMine

Ah Yes...this was started shortly after ISeeYou, however I hadn't noticed back then, that I definetly needed a break.
This was supposed to become a big project (scope of 1-1.5 years) and was supposed to become a metroidvania.
I played around with some mechanics, like walljump and even a grappling hook mechanic. However life is life, and I hadn't worked on it ever since.
But the grappling hook mechanic is very neat. Room for improvement ofc.

## NecromancerDefense

This was created before Toastjump, I didn't know about a GDD and I just "started to do things" instead of properly planning ahead what I wanted to do. It was supposed to be a PlantsVsZombie clone. You are a Necromancer and the holy church tries to eradicate you. Summon Zombies and defend yourself.

So PvZ but different settings and I thought about making the Game mechanics more complex.

However my inexperience kicked in rather quickly and the game became way to complicated in its design (programatically speaking)

But there are still some neat mechanics and proofs of concepts so...yea

In the future I come back to this. Better prepared.

Also this is incompatible with newer Godot Versions. (Semi Works with Godot v.4.3)

### Minor showcase

You have a rudimentary starting menu, world select and then a stage select.
You were able to "play" the game by placing your zombies, and await the enemy waves and defeting them.
Unlocking a new Pawn / Summon after each wave.

You were allowed to play any stage at any time. But might be underpowered. So my intention was:
If you want to, you can but you shouldn't...but you can certainly try.

#### Start Screen an World/Stage-select
<p>
<img src="/showcase/necromancerdefense/startscreen.png" alt="Some showcase of the prototype stage" width = 300><br><br>
<img src="/showcase/necromancerdefense/world_select.png" alt="Some showcase of the prototype stage" width = 300>
<img src="/showcase/necromancerdefense/world_select_description.png" alt="Some showcase of the prototype stage" width = 300><br><br>
<img src="/showcase/necromancerdefense/stageselect.png" alt="Some showcase of the prototype stage" width = 300>
<img src="/showcase/necromancerdefense/stage_select_hover.png" alt="Some showcase of the prototype stage" width = 300>
</p>

#### Level

<p>Showing the prototype of a tutorial level -> only one lane is accessable.</p>

<img src="/showcase/necromancerdefense/preparelevel_zombieselect.png" alt="Zombie selection" width = 300>
<img src="/showcase/necromancerdefense/placingyourzombies.png" alt="Zombie placement" width = 300><br>
<img src="/showcase/necromancerdefense/attacks.png" alt="attack showcases" width = 300>





## Kuhlifumdenteich

This was ... a thought.. I wanted to create an idle orthografic cozy game, where you can create a world, collect ressources and watch a world unfold.

Well...It didn't even enter the prototype stage. This were the very early days of my godot journey. But projecting your mouse position into the orthografic world and instantiating objects/resource creators at the correct position...mechanically speaking / learning experience...it was great.

### Idea

You have different Tiletypes where different resourcecollectors (like lumberjack, fishhut etc) can be placed.
Depending on the quality of the Tile you can increase your output of collected resources.
You get a preview of the quality so you know in advance if it is good to place a resource there.


#### Good vs Bad Spot

<img src="/showcase/kuhlifumdenteich/spotquality_bad.png" alt="Some showcase of the prototype stage" width = 300>
<img src="/showcase/kuhlifumdenteich/spotquality_great.png" alt="Some showcase of the prototype stage" width = 300>

## Placed Buildings

<img src="/showcase/kuhlifumdenteich/buildings.png" alt="Some showcase of the prototype stage" width = 300>


##### Learnings

I mean I learned how to move the 3D camera within ortho space and was able to zoom in and out to a min/max etc.
Placing buildings on a 3d Grid and preview the building depending on the quality...I mean there were a lot of learnings there.
I'd prob. do those things differently than back then (Feb 2024)
