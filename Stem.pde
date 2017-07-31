//stem segments for the seaplants, based on the rotational mass spring damper system

class Stem {
  //various values for physical variables
  float angle = 0 ;                            //initial starting angle
  float aVelocity = 10;                        //angular velocity
  float acceleration = 0;                      //acceleration (by the water stream)
  float dampingConstant = 0.6;                 //damping constant
  float springConstant = 0.02;                 //spring constant
  float mass = 50;                             //mass
  float fd;                                    //damping force
  float fs;                                    //spring force
  float fm;                                    //mass force
  float momentum;                              //momentum
  float yPosition;                             
  float xPosition;
 

  Stem(float xPosition_, float yPosition_) {   //Constructor with x and y position

    yPosition = yPosition_;
    xPosition = xPosition_;
  }

  void display() {                       //display a stem segment

    angle += aVelocity;                  //give the stem an angle to rotate based on the mass spring damper system!
    angle += acceleration;               //add acceleration from a force (e.g. wind, stream, etc.), keeps it moving
    rotate(radians(angle));              //rotate!
    stroke(#0CA526);
    strokeWeight(2);                   //make the line a bit thicker
    line(0, 0, 0, -20);
    translate(0, -yPosition);            //set a new origin for the next stem
    acceleration *= 0;                   //set the acceleration of the water stream back to 0, prevents the stream from getting stronger and stronger
    strokeWeight(1);                     //set strokeWeight back to 1
  }

  void applyForce(float force) {         // Receive a force, divide by mass, and add to acceleration.
    float f = force/mass;
    acceleration += f;
  }

  void move() {
    // fd = d * v                        (damping times velocity)
    // fs = integral of v*k              (k is the spring constant)
    // v = integral of the force * 1/m    

    fd = dampingConstant * aVelocity;
    angle += aVelocity;
    fs = angle * springConstant;    
    fm = -fd - fs;
    momentum += fm;
    aVelocity = momentum  * (1/mass);
  }
}