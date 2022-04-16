# Quest-for-the-Golden-Pi
A 16bit Maze Game written in 8086 assembly.

Purpose: Resume

The story:

You are an unnamed adventurer who is tasked by the king with find and retrieving a relic call the Golden Pi and in return you will be given an award if you return. But unknown to you another seeks the rewards. A man called the Hunter follows you into the maze. The game is a maze navigating survival game.

How to play:

I know that this game will be difficult to run as it requires a system able to run 16bit code, so to allow for it to be scene running I have made a video of the game being played. {Youtube Video}

The controls are WASD, if you attempt to walk into a wall the game will beep at you.

How it works:

The game is written using 8086 assebly code and was programmed using the Emu8086 emulator, which allows for the writing of 16bit assembly, the running of 16bit assembly code and the viewing of memory and regesters during runtime to debug said code.

The code starts off by hiding the console cursor and clear the screen of anything currently on it. 

We then enter into the SceneManager where we handle the openning cutscene and getting the game to the gameLoop where the player will gain control of the character. 

The gameLoop consists of checking using inputs, checking collision and storing the players moves for the Hunter to use in Stalking the player.

Next is the map render system, this is the procedure that takes in the map data from the 2D arrays and renders the ascii characters into the console window. This works alongside the drawProps procedure which takes prop data from a collection of 1D arrays to place and color the world details that help immerse the player.

Then we get to the NPCManager which controls moving the NPC characters in the cutscenes.

Next is the textRender which acts just like the map render system excepts only handles rendering the text during cutscenes and when the Hunter shows up.

After some text data we arrive at the ItemsManager which just checks to see if the player has attempted to pick up the Golden Pi, if so the Golden Pi is set to being picked up and the game then moves to phase 2.

Next procedure is handling player inputs, determining what they input and what direction the player would move based on the input.

When the maps load the SpawnPlayer prcedure runs and places the player into the game window and marks where they are for future movements.

The rest of the code is for the Hunter's stalking ability. Once the player picks up the Golden Pi the Hunter will appear and begin hunting the player down. This means it starts to log all of the players inputs and start to copy them EXCEPT it will remember a move which caused the player to collide with a wall. This means if the player makes too many mistakes they Hunter will catch them and if the player and the Hunter collide the game ends, cuts to a cutscene with the Hunter receiving the reward.
