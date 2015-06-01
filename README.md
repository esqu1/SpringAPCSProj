```
YYYYYYY       YYYYYYY                        tttt                            lllllll   iiii                   
Y:::::Y       Y:::::Y                     ttt:::t                            l:::::l  i::::i                  
Y:::::Y       Y:::::Y                     t:::::t                            l:::::l   iiii                   
Y::::::Y     Y::::::Y                     t:::::t                            l:::::l                          
YYY:::::Y   Y:::::YYYaaaaaaaaaaaaa  ttttttt:::::ttttttt    uuuuuu    uuuuuu   l::::l iiiiiiinnnn  nnnnnnnn    
   Y:::::Y Y:::::Y   a::::::::::::a t:::::::::::::::::t    u::::u    u::::u   l::::l i:::::in:::nn::::::::nn  
    Y:::::Y:::::Y    aaaaaaaaa:::::at:::::::::::::::::t    u::::u    u::::u   l::::l  i::::in::::::::::::::nn 
     Y:::::::::Y              a::::atttttt:::::::tttttt    u::::u    u::::u   l::::l  i::::inn:::::::::::::::n
      Y:::::::Y        aaaaaaa:::::a      t:::::t          u::::u    u::::u   l::::l  i::::i  n:::::nnnn:::::n
       Y:::::Y       aa::::::::::::a      t:::::t          u::::u    u::::u   l::::l  i::::i  n::::n    n::::n
       Y:::::Y      a::::aaaa::::::a      t:::::t          u::::u    u::::u   l::::l  i::::i  n::::n    n::::n
       Y:::::Y     a::::a    a:::::a      t:::::t    ttttttu:::::uuuu:::::u   l::::l  i::::i  n::::n    n::::n
       Y:::::Y     a::::a    a:::::a      t::::::tttt:::::tu:::::::::::::::uul::::::li::::::i n::::n    n::::n
    YYYY:::::YYYY  a:::::aaaa::::::a      tt::::::::::::::t u:::::::::::::::ul::::::li::::::i n::::n    n::::n
    Y:::::::::::Y   a::::::::::aa:::a       tt:::::::::::tt  uu::::::::uu:::ul::::::li::::::i n::::n    n::::n
    YYYYYYYYYYYYY    aaaaaaaaaa  aaaa         ttttttttttt      uuuuuuuu  uuuulllllllliiiiiiii nnnnnn    nnnnnn
```

Research suggests that there is a strong correlation between size of a team name and amazingness of said team's
final submission.

Project Name: Wrecking Ball<br />
(This is to distinguish it from Dennis's project from term one of Intro – Wreckerball.)<br />
(Coincidentally, this team name also has its roots in term one of Intro...)<br />


DEVELOPMENT LOG:<br />

5/20/15<br />
Brandon created this directory.

5/22/15<br />
Brandon made a couple of skeleton files for classes that might come in handy.

5/23/15<br />
Dennis discovered that he could write code on his phone, which greatly amused him.

5/25/15<br />
Brandon made a simple paddle that could follow the player's mouse.

5/26/15<br />
Brandon started writing an abstract Brick class and wrote the constructor for a rectangular prism subclass.<br />
Dennis started writing the Board class, which will contain all objects involved in the game.<br />
Dennis then modified the WreckerBall class to allow users to resize the board (rather, resize everything in
the game window), rotate the board, zoom toward and away from the board, and reset to default settings.

5/27/15<br />
Brandon figured out how to draw brick prisms with irregular polygons as faces. He also started working on a method that would detect collisions between the ball and a prism. <br />
Dennis made the board 1x1 in the hopes that this would make coding the levels simpler.

5/28/15<br />
Brandon figured out how to work textures onto the bricks. <br />
Dennis realized that his board scaling idea was stupid and that his former board resizing idea was flawed.<br />
Dennis then came up with an outline for detecting collisions between a ball and a prism.

5/29/15<br />
Dennis reimplemented zooming and window resizing using a compination of the camera() and perspective() functions.<br />
Dennis then redid Brandon's texture-drawing mechanism so that the textures would not be scaled as they were drawn.<br />
Dennis then started writing the collision detection function.

5/30/15<br />
Dennis continued writing the collision detection function, which he realized was mad work.<br />
Taking a break, Dennis added lighting to the game, and then wrote a lot of useful mathematical functions to be used in the collision detection function, as well as anywhere else they may be needed.<br />

5/31/15<br />
Dennis realized that Processing's left-hand coordinate system had been causing his vector determinants to return the negatives of the values he was expecting.<br />
After correcting that issue, Dennis wrote a function for reflecting balls off the edges of prisms.<br />
Dennis then fixed an issue that occured when balls collided with vertices of prisms, finishing off the ball-bouncing mechanism.<br />
Dennis then created a Container class that would hold various elements in the board.<br />
Finally, Dennis started working on a way to add textures to balls.

6/1/15<br />
Brandon wrote a Cylinder class for a new kind of brick.