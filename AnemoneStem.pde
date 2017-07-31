//Via use of inheritance we extend this class to the original stem class (take over functions, etc)
//Is used now for anemone stems instead of grass stems

class AnemoneStem extends Stem {

  AnemoneStem(float xPosition_, float yPosition_) {
    super(xPosition_, yPosition_);
  }

  //override display function
  void display() {
    angle += aVelocity;                     //give the stem an angle to rotate based on the mass spring damper system!
    angle += acceleration;                  //add acceleration from a force (e.g. wind, stream, etc.), keeps it moving
    rotate(radians(angle));                 //rotate!
    
    stroke(#B2E8F5);                      //give it another color!
    strokeWeight(12.5);                   //make it thicker!
    line(0, 0, 0, -80);
    translate(0, -yPosition);            //set a new origin for the next stem
    acceleration *= 0;                   //set acceleration back to 0, prevents infinite acceleration
    strokeWeight(1);
    noStroke();
  }
}