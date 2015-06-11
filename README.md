```
___________                     _____.___.       __        .____    .__        
\__    ___/___ _____    _____   \__  |   |____ _/  |_ __ __|    |   |__| ____  
  |    |_/ __ \\__  \  /     \   /   |   \__  \\   __\  |  \    |   |  |/    \ 
  |    |\  ___/ / __ \|  Y Y  \  \____   |/ __ \|  | |  |  /    |___|  |   |  \
  |____| \___  >____  /__|_|  /  / ______(____  /__| |____/|_______ \__|___|  /
             \/     \/      \/   \/           \/                   \/       \/ 
```

Project Name: Wrecking Ball<br />
(This is to distinguish it from Dennis's project from term one of Intro – Wreckerball.)<br />
(Coincidentally, this team name also has its roots in term one of Intro...)<br />


DEVELOPMENT LOG:<br />

5/20/15<br />
Brandon created this directory.

5/22/15<br />
Brandon made a couple of skeleton files for classes that might come in handy.

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
Dennis reimplemented zooming and window resizing using a combination of the camera() and perspective() functions.<br />
Dennis then redid Brandon's texture-drawing mechanism so that the textures would not be scaled as they were drawn.<br />
Dennis then started writing the collision detection function.

5/30/15<br />
Dennis continued writing the collision detection function, which he realized was mad work.<br />
Taking a break, Dennis added lighting to the game, and then wrote a lot of useful mathematical functions to be used in the collision detection function, as well as anywhere else they may be needed.<br />

5/31/15<br />
Dennis realized that Processing's left-hand coordinate system had been causing his vector determinants to return the negatives of the values he was expecting.<br />
After correcting that issue, Dennis wrote a function for reflecting balls off the edges of prisms.<br />
Dennis then fixed an issue that occured when balls collided with vertices, finishing off the ball-bouncing mechanism for prisms.<br />
Dennis then created a Container class that would hold various elements in the board (because the ArrayList class was too inefficient for him).

-- The "june1" branch contains the demo version. --

6/1/15<br />
Brandon started writing a Cylinder class for a new kind of brick, while Dennis started writing a Sphere class.<br />
Brandon also made the balls on the board detect when they were out of bounds, and made them reflect if they did.<br />
Dennis then created an M.java class that would house all static math-related methods.<br />
Dennis then made some changes in order to accomodate a menu.<br />

6/2/15<br />
Dennis made a draw() method for cylinders that only allowed for solid colors (rather than textures).

6/3/15<br />
Brandon wrote code for a menu screen.<br />
Dennis made a ball-bouncing mechanism for cylinders, which was much simpler than the one for prisms.

6/4/15<br />
Brandon made two spheres in the background of the menu that collided, but the physics behind their collision may have been screwed up.<br />
Brandon also fixed an issue where the balls would glue together when loading.<br />
Dennis made a ball-bouncing mechanism for spheres, which was simpler than both the previous ones he had written.<br />
Dennis then started working on a way to add textures to cylinders.

6/5/15<br />
Dennis finished off the texturing mechanism for cylinders.<br />
Dennis then rewrote Brandon's out-of-bounds detection mechanism for balls.<br />
Dennis then spent some time working on a way to add textures to spheres, but couldn't get it quite right.

6/6/15<br />
Dennis created a superb texturing mechanism for spheres.<br />
Dennis then changed the draw() functions of prisms and cylinders to make them much more efficient and to make the code more consistent.<br />
Dennis then allowed spheres to spin around a central axis and put a spinning model of the Earth on the board.<br />
Dennis then used Photoshop to make a high-resolution gray brick texture that could be used later on.

6/7/15<br />
Brandon created an options menu that allows the user to change the smoothness of the game.<br />
While doing this, Brandon fixed a bug that would cause the user to start playing the game while adjusting smoothness.<br />
Brandon also realized that he was being silly and his computer doesn't support smoothness, but he implemented it anyway.<br />
Dennis discovered that Processing had been producing the wrong lighting for all of his bricks, and had to manually set the lighting conditions for each vertex.<br />
Dennis then found a bunch of very high-resolution textures of celestial bodies that could be used later on.

6/8/15<br />
Dennis made a paddle that was essentially a modified prism whose shape followed the equation y = 0.2(x^6 - 1).<br />
Dennis then started working on turning bricks into nodes of doubly-linked lists so that they could be stacked one on top of another.

6/9/15<br />
Dennis allowed bricks to accelerate downwards when the bricks under them were destroyed and then bounce up and down in dampened simple harmonic motion.<br />
Dennis then gave bricks velocities in the x and y directions as well, so that they could move back and forth along pre-defined paths.<br />
Dennis then gave bricks angular velocities, so that they could rotate in place or, in the case of spheres, roll along the ground.<br />
Dennis then redid all the constructors for each type of brick to make them more elegant and efficient, and he also cleaned up the ball-bouncing code.<br />
Finally, Dennis made the design of new levels much simpler.

6/10/15<br />
Dennis redid the brick-falling mechanism to make it more physically accurate and to allow for anti-gravity.<br />
Dennis then worked on a way for multiple bricks to be put directly on top of a given brick and for one brick to be put on top of several bricks.
