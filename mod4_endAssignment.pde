/*
 Creative Technology, Algorithms for CreaTe
 Final assignment, module 4
 Nils Rublein & John Kim
 s1864432 & s1875574
 Processing 3.2.1 
 25/06/2017
 
 This programme simulates an ocean floor with the use various programming physics such as:
 -mass spring damper system for sea grass, a fishing hook and an anemone
 -perlin noise to generate a random landscape every time the program is run
 -particles for the chest bubbles
 -water stream representing the underwater force that influences the grass movement (Perlin noise that keeps the mass spring damper system moving)
 -flocking physics with the swimming fishes
 -repelling & attracting forces (Magic carp / the fishing hook)
 -UNDER THE SEA MUSIC!
 
 Interactions:
 -Controll the magic carp via the mouse
 -Let bubbles spawn from the chest by clicking on the chest
 -Let the fishing hook sink and rise by pressing any key
 */

import java.util.*;
import processing.sound.*;
SoundFile music;



Flock flock;                              //calling classes
MainFish MainFish;
Chest chest;
BackGround backGround;
landscape sand;
Hook hook;
Liquid liquid;
Particle p;
ScreenStateMachine stateMachine;     //State machine

ArrayList<Particle> particles;      //declare an arrayList of particle bubbles
PVector location;                  //location for particle bubbles
PImage ocean;
int x =-100;                       //initial position for bubbles (offscreen)
int y = 1;
int MAX = 30;                      //maximum of bubble particles 

int xPos = width/2+1050;         //position for bubbles spawn 
int yPos = height+730;

////////////////////////////////////SETUP//////////////////////////////////////

void setup() {

  size(1600, 900);
  frameRate(30);
  music = new SoundFile(this, "underthesea.mp3");
  music.play();

  backGround = new BackGround();

  hook = new Hook(random(0.5*2.25, 3*2.25), width/2+300, 0);                      //Constructor (mass, x,y)
  PVector gravity = new PVector(0, 0.1*hook.fallingMass);                            
  hook.applyForce(gravity);                                                       //let the fishing hook sink!  
  //apply gravity again
  liquid = new Liquid(0, height/2, width, height/2, 0.1);         //Create liquid object for the fishing hook
  sand = new landscape(880, 890, #E5D199);                        //sand

  flock = new Flock();                                            //fish flocking
  chest = new Chest();                                            //chest 

  location = new PVector (x, y);                                  //starting position for bubbles
  particles = new ArrayList<Particle>();                          //Make an arraylist of particles

  for (int i = 0; i < MAX; i++) {                                 //Make new bubble particles at this location
    particles.add(new Particle (location));
  }

  for (int j = 0; j < 150; j++) {                                          // Add an initial set of fishes into the system
    Fish f = new Fish(width/2, height/2);                                 //let them spawn at the center
    flock.addFish(f);                                                    //add them to the flocking system
  }

  MainFish = new MainFish(width/2, height/2);                          //initialize our main fish

  //The following sets up the main structure of the state machine
  //First it matches the names of the ScreenStates to the instances of events
  //Second, it defines the list of successor screens for each screen 
  Map<ScreenState, Screen> screens = new HashMap<ScreenState, Screen>();
  screens.put(ScreenState.STATE_1, new State1(new ScreenState[] {ScreenState.STATE_2}));     //State1 is when fishing hook drops down
  screens.put(ScreenState.STATE_2, new State2(new ScreenState[] {ScreenState.STATE_1}));     //State2 is when it goes back up
  stateMachine = new ScreenStateMachine(screens, ScreenState.STATE_1);                       //Start with State1!
}

///////////////////////////////////////DRAW////////////////////////////////////////////////

void draw() {

  backGround.display();
  chest.display();                                      //display a chest
  chest.rattle();                                      //let it rattle if you click on it
  hookRun();                                           //run functions for the fishing hook (displaying, physical behaviour, attraction (and repelling!) of smaller fishes

  for (int i = 0; i < particles.size(); i++) {
    Particle p =  particles.get(i);                   //makes p a particle equivalent to i'th particle in ArrayList, make a particle at position i
    p.run();                                         //display and update the particles
  }

  PVector target = new PVector (mouseX, mouseY);   //set the mouse as target location for our main fish

  flock.run();                                    //run the flocking system and repel the fishes from the main fish
  flock.applyRepel(MainFish);                 //let the main fish repel the small fishes

  MainFish.arrive(target);                      //let the main fish 'arrive' at the mouse location (stop at the mouse)
  MainFish.update();                           //update and display the main fish
  MainFish.display();
  sand.display();                            //display the sand (also generated by perlin noise)

  stateMachine.doAvailableTransitions();     //execute the state machine's functions
  stateMachine.drawScreen();                 //use draw of the current state ( state1 or state2)
}

///////////////////////////////////////////OTHER FUNCTIONS////////////////////////////////////////////////

void hookRun() {
  if (liquid.contains(hook)) {                        // Is the hook in the liquid?
    PVector dragForce = liquid.drag(hook);            // Calculate drag force
    hook.applyForce(dragForce);                       // Apply drag force to hook
  }

  // Update and display
  PVector target = new PVector(hook.location.x, hook.location.y+100 );
  hook.update();
  hook.displayThis();
  hook.stopHook();
  hook.arrive(target);
}

void mouseReleased() {

  //if you click on the chest and release the mouse, bubbles will spawn at the chest's keyhole

  if (mouseX > width/2+250-100 && mouseX < width/2+250+100 && mouseY > height-105-90 && mouseY <height-105+90) {     //define a 'button'
    for (int i = 0; i < particles.size(); i++) {
      Particle p =  particles.get(i);                                                                               //new particles at this position!

      location = new PVector(xPos, yPos);                                       //set the location for the bubbles

      p.revive(location);                                    //re-initialize values like position, velocity etc. for the bubble particles. 
      //This serves as a 'remove() function' and prevents infinte loops (too many bubbles)
    }
  }
}

void keyPressed() {                   
  stateMachine.handleKeyPress();
}