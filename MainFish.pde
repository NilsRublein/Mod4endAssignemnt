//Class for the Main Fish object, which lets the fish arrive at the mouse's position and also repells smaller fishs

class MainFish {

  float strength = 250;            //How strong is the repelling force of the MainFish?
  PVector location;                //values for location, velocity and acceleration
  PVector velocity;
  PVector acceleration;
  float maxspeed;                  //values for maxspeed and maxforce
  float maxforce;                  //used for steering
  PImage img;                      //2 images for our fish, both being the same image, just flipped.
  PImage img2;                     //If the fish changes his direction, use the other image
  MainFish(float x, float y) {     //constructor with x and y position

    location = new PVector(x, y);              // initial location
    acceleration = new PVector(0, 0);          //set initial acceleration and velocity to 0
    velocity = new PVector(0, 0);
    maxspeed = 9;
    maxforce = 0.3;

    img = loadImage("129Magikarp_AG_anime.png");      //load both images
    img2 = loadImage("2129-Shiny-Magikarp2.png");
  }

  void display() {

    float theta = velocity.heading2D() + PI/2;       //Draw a fish rotated in the direction of velocity
    pushMatrix();

    translate(location.x, location.y);               //translate to x and y 
    rotate(theta);
    if (mouseX < location.x) {                              //based on the angle we are displaying 2 different images, one is facing to the left, the other to the right
      image(img, -56, -65, 113, 129.3);
    } else if (mouseX > location.x ) {
      image(img2, -56, -65, 113, 129.3);
    }
    popMatrix();
  }

  void update() {                       //update acceleration, location etc. for each frame
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity); 
    acceleration.mult(0);              //set acceleration back to 0, prevents the acceleration from becoming infinitely large
  }

  void applyForce(PVector force) {      //apply a force (steering in this case)
    acceleration.add(force);
  }


  PVector repel(Fish f) {                              //function for repelling , only repells the small fishes

    PVector dir = PVector.sub(location, f.position);   //force direction, equals location of the main fish subtracted with the position

    float d = dir.mag();                               //d equals the length of the vector of the force direction 
    d = constrain(d, 5, 400);                          //everyting in this radius gets repelled

    dir.normalize();
    float force = -1 * strength / (d * d);             //calculate the magnitude 
    dir.mult(force);                                   //make a vector out of direction and magnitude
    return dir;                                        //and return it
  }


  void arrive(PVector target) {                               //function that lets the main Fish arrive / stop at a target (the mouse's location in this case)
    PVector desired = PVector.sub(target, location);

    float distance = desired.mag();                           // The distance is the magnitude/length of the vector pointing from location to target
    desired.normalize();

    if (distance < 100) {                                    // If we are closer than 100 pixels 
      float m = map(distance, 0, 100, 0, maxspeed);         // set the magnitude/length according to how close we are.
      desired.mult(m);
    } else {
      desired.mult(maxspeed);                             // Otherwise, proceed at maximum speed.
    }

    PVector steer = PVector.sub(desired, velocity);     // The usual steering = desired velocity - current velocity
    steer.limit(maxforce);                             //limit it to maxforce
    applyForce(steer);                                //add steering to acceleration
  }
}