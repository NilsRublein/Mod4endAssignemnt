//Class for the flocking for the school of fish. Defines the look of the fish, and functions for the behaviour of the fish (separation, alignment and cohesion).

class Fish {

  PVector position;          //position, velocity and acceleration 
  PVector velocity;
  PVector acceleration;
  float r;                   //size of the fish
  float maxforce;            //Maximum steering force
  float maxspeed;            //Maximum speed

  Fish(float x, float y) {  //constructor of the fish, with the spawning location of the fish
  
    acceleration = new PVector(0, 0);                              //set initial acceleration to 0
    velocity = new PVector(random(-1, 1), random(-1, 1));          //give them a random velocity between -1 and 1
    position = new PVector(x, y);
    r = 30.0;                                                      //size for the fishies
    maxspeed = 3;                                                  //set a maximum speed for the fishes
    maxforce = 0.05;                                               //set a maximum force value for the fish 
  }

  void run(ArrayList<Fish> Fishes) {             //function to summaraize all the other functions, calling all functions at the same time with void run
    flock(Fishes);
    update();
    render();
    bounceWalls();
  }

  void applyForce(PVector force) {               //function to apply the force to acceleration (is used for steering)
    acceleration.add(force);
  }


  void flock(ArrayList<Fish> Fishes) {            // We accumulate a new acceleration each time based on three rules
    PVector sep = separate(Fishes);               // Separation, steers the fishies away
    PVector ali = align(Fishes);                  // Alignment, gives them an average velocity
    PVector coh = cohesion(Fishes);               // Cohesion, steers them to each other, keeps them together

    sep.mult(1.25);                               // Arbitrarily weigh these forces
    ali.mult(1.0);
    coh.mult(1.0);

    applyForce(sep);                             // Add the force vectors to acceleration
    applyForce(ali);
    applyForce(coh);
  }


  void update() {                                // Method to update position 
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity); 
    acceleration.mult(0);                        // Reset accelertion to 0 each cycle
  }


  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED VELOCITY MINUS CURRENT VELOCITY or 
  //"how strong it desires to move (a vector pointing to the target), in comparison with how quickly it is currently moving (its velocity), 
  //and apply a force accordingly
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);      // A vector pointing from the position to the target
    desired.normalize();                                  // Normalize desired and scale to maximum speed
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);       // Steering = Desired minus Velocity
    steer.limit(maxforce);                                // Limit to maximum steering force
    return steer;
  }


  void render() {  //function to display the fish
  
    float theta = velocity.heading() + radians(90);  // Draw a fish rotated in the direction of velocity
    pushMatrix();

    translate(position.x, position.y);
    rotate(theta);

    stroke(0);
    fill(255, 0, 0);                        //body
    ellipse(0, 0, r/2, r);
    fill(255);
    ellipse(-r/8, -r/5, r/5, r/5);
    fill(0);
    ellipse(-r/8, -r/5, r/12, r/12);

    pushMatrix();                          //fins
    rotate(PI/3);
    fill(255);
    ellipse(r/5, 0, r/2.5, r/5);
    popMatrix();

    pushMatrix();                           //tail
    rotate(PI);
    noFill();     
    strokeWeight(5);
    stroke(255);
    arc(0, -r/1.4, r/2, r/2, 0, PI, OPEN);
    strokeWeight(1);
    noStroke();
    popMatrix();

    popMatrix();
  }


  // Separation
  // also "the average of all the vectors pointing away from any close vehicles"
  // Method checks for nearby Fishes and steers away
  PVector separate (ArrayList<Fish> Fishes) {                    // check for other fish in the arraylist
    float desiredseparation = 25.5f;                             // desired seperation value
    PVector steer = new PVector(0, 0, 0);
    int count = 0;

    for (Fish other : Fishes) {                                 // For every Fish in the system, check if it's too close
      float d = PVector.dist(position, other.position);         // calculate the distant between this fish and another fish from the list
      if ((d > 0) && (d < desiredseparation)) {                 // If the distance is greater than 0 and less than an arbitrary amount 
                                                                // (prevents the fish comparing with itself since 0 is the 'current' fish)  
        PVector diff = PVector.sub(position, other.position);   // Calculate vector pointing away from neighbor
        diff.normalize();
        diff.div(d);                                            // Weight by distance
        steer.add(diff);                                        // What is the magnitude of the PVector pointing away from the other vehicle?
                                                                // The closer it is, the more we should flee. The farther, the less. So we divide by the distance to weight it appropriately.
        count++;                                                // Keep track of how many
      }
    }
    if (count > 0) {                                            // Average -- divide by how many
      steer.div((float)count);
    }

    if (steer.mag() > 0) {                                      // As long as the vector is greater than 0
                                                                // Implement Reynolds: Steering = Desired velocity - current Velocity
      steer.normalize();
      steer.mult(maxspeed);                                     // scale to max speed
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  PVector align (ArrayList<Fish> Fishes) {                      // For every nearby Fish in the system, calculate the average velocity
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Fish other : Fishes) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);                               //Add up all the velocities and divide by the total to calculate the average velocity.
        count++;                                               // For an average, we need to keep track of how many boids are within the distance.
      }
    }
    if (count > 0) {
      sum.div((float)count);                                  //divide to get the average
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);             // Implement Reynolds: Steering = Desired velocity - current Velocity
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);                           //if we don't find any boids, steering force is zero
    }
  }

  // Cohesion

  PVector cohesion (ArrayList<Fish> Fishes) {                     // For the average position (i.e. center) of all nearby Fishes, calculate steering vector towards that position
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);                             // Start with empty vector to accumulate all positions
    int count = 0;
    for (Fish other : Fishes) {
      float d = PVector.dist(position, other.position);          //get the distance between this fish  and other fishes
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position);                                // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);                                           //get the average by dividing
      return seek(sum);                                         // Steer towards the position
    } else {
      return new PVector(0, 0);                                  //if we don't find any boids, steering force is zero
    }
  }

  void bounceWalls () {                      //let the fishies bounce from the top and bottom walls by flipping the velocity value, and mirror the sides

    position.add(velocity);                  //give them a direction value at the spawn position

    if (position.x < -r) position.x = width+r;           //let the fish swim continuously with open side borders      
    if (position.x > width+r) position.x = -r;

    if ((position.y < r)) {                              //give a boundary so the fish dont swim past the top of the screen
      position.y = r;
      velocity.y = velocity.y * -1;
    }

    if ((position.y > height-r)) {                       //give a boundary so the fish do not swim below the bottom of the screen.
      position.y = height-r;
      velocity.y = velocity.y * -1;
    }
  }
}