//Class for our repeller object, a magic carp in this case

class Hook {

  Hookline hookline;               //hookline is class containing the physical behaviours from the mass spring damper system and the display function for the hook
  float strength = 250;            //How strong is the attractinve strength?
  PVector location;
  PVector velocity;
  PVector accelerationFall;                     
  float maxspeed;
  float maxforce;
  float G;                       //Gravity
  float fallingMass;
  float waterStreamIncrement; 

  Hook(float m, float x, float y) {

    location = new PVector(x, y);
    accelerationFall = new PVector(0, 0);
    velocity = new PVector(0, 0);

    fallingMass = m;
    maxspeed = 7.5;
    maxforce = 0.3;
    G = 0.4;
    waterStreamIncrement = 0;

    hookline = new Hookline(0, 80);
  }

  void displayThis() {

    pushMatrix();
    translate(location.x, location.y);                           //initial origin

    float waterStreamNoise = noise(waterStreamIncrement);        //again, increment a noise value for the waterstream
    float waterStream = map(waterStreamNoise, 0, 1, -1, 20);     //and map it to give it a more suitable range
    waterStreamIncrement += 0.01;


    //display, move and apply the water stream force to the hook
    hookline.display();
    hookline.move();
    hookline.applyForce(waterStream);

    popMatrix();
  }

  void update() {
    velocity.add(accelerationFall);                 //let the hook fall down
    velocity.limit(maxspeed);
    location.add(velocity);
    accelerationFall.mult(0);                       //multiply by zero to prevent infinite acceleration
  }

  void applyForce(PVector force) {                   // Newton's 2nd law: F = M * A, is in this case being used for letting the hook fall down
    PVector f = PVector.div(force, fallingMass);
    accelerationFall.add(f);
  }

  PVector attract(Fish f) {                              //function for attracting
    // The distance is the magnitude of the vector pointing from location to target
    PVector dir = PVector.sub(location, f.position);
    float d = dir.mag();                     

    dir.normalize();                                   //make it a unit vector
    d = constrain(d, 32, 50);                          // everyting in this radius gets attracted
    float force = (G * strength) / (d * d);
    dir.mult(force);
    return dir;
  }

  PVector repel(Fish f) {                              //function for repelling
    PVector dir = PVector.sub(location, f.position);
    float d = dir.mag();

    dir.normalize();                                     //make it a unit vector
    d = constrain(d, 100, 100);                          // everyting in this radius gets repelled
    float force = (G * strength) / (d * d);
    dir.mult(force);
    return dir;
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location);

    // The distance is the magnitude of the vector pointing from location to target
    float d = desired.mag();
    desired.normalize();

    if (d < 100) {                                    // If we are closer than 100 pixels... 
      float m = map(d, 0, 100, 0, maxspeed);         // ...set the magnitude according to how close we are.
      desired.mult(m);
    } else {

      desired.mult(maxspeed);                        // Otherwise, proceed at maximum speed.
    }

    PVector steer = PVector.sub(desired, velocity);  // The usual steering = desired - velocity
    steer.limit(maxforce);
    applyForce(steer);
  }

  void stopHook() {                              // let the hook stop at height-400
    if (location.y > height-400) {
      velocity.y *= 0;                  
      location.y = height-400;
    }
  }
}