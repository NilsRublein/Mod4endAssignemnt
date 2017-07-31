class Hookline extends Stem {
  PImage img;
  int sizeX;
  int sizeY;
  Hookline(float xPosition_, float yPosition_) {
    super(xPosition_, yPosition_); 
    img = loadImage("fishingHook.png");

    sizeX = 50;
    sizeY = 120;
  }

  void display() {
    angle += aVelocity;                               //give the stem an angle to rotate based on the mass spring damper system!
    angle += acceleration;                            //add acceleration from a force (e.g. wind, stream, etc.), keeps it moving
    rotate(radians(angle));                           //rotate!
    stroke(#D3B417);
    line(xPosition+8.75,-600, xPosition+8.75, yPosition-5);
    image(img, xPosition-30, yPosition-20, sizeX, sizeY);
    acceleration *= 0;
    noStroke();
  }
}