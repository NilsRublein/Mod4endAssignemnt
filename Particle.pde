//This class uses particles to spawn bubbles at the chest's location and keeps track of the lifespann of each individuell bubble

class Particle {  
  PVector location;        //location, velocity and acceleration
  PVector velocity;
  PVector acceleration;
  float lifespan;          //lifespan for each particle so they dont remain forever

  Particle(PVector l) {    //constructor with PVector location

    acceleration = new PVector(0, random(-0.05, -0.02));       //negative accelereation making bubbles flow upward
    velocity = new PVector(random(-1, 1), random(0, 0.1));    //random speed for bubbles
    location = l.get();  
    lifespan = 255.0;                                        //set the bubbles lifespan to 255.0 time value 
  }



  void run() {                                            // function that calls all the other functions we need at once.
    update();
    display();
  }

  void update() {                                       //update acceleration, velocity and lifespan for each frame
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.2;                                  //slowly fade out 
  }

  void display() {                                  //display bubbles
    stroke(0, lifespan);                           //using lifespan for the alpha value for transparency  
    strokeWeight(2);
    fill(#BBECFA, lifespan);
    ellipse(location.x, location.y, random(40, 45), random(40, 45));  //random bubble sizes 
  }

  void revive(PVector l) {                                       //re-initialise values such as position, acceleration etc. These are the same starting values we gave.
    acceleration = new PVector(0, random(-0.05, -0.02));         //This serves as a 'remove() function' and prevents infinte loops (too many bubbles)
    velocity = new PVector(random(-1, 1), random(0, 0.1));
    location = l.get();
    lifespan = 255.0;
  }

  boolean isDead() {         // Is the Particle alive or dead? 
    if (lifespan < 0.0) {    //check the lifespan, if the lifespan is 0, return true ( they're dead)
      return true;
    } else {                 //otherwise return false (they're still alive)
      return false;
    }
  }
}