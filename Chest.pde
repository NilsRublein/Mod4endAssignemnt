//Class for displaying and rattling of a treasure chest

class Chest {
  PImage image; //importing image 
  int xPos;     //values for position and size
  int yPos;
  int sizeY;
  int sizeX;

  Chest() {  //constructor 
    sizeX = 200;          //initial values
    sizeY = 180;
    xPos = width/2+200;
    yPos = height-150;

    image = loadImage("chest.png");  //calling image from data file
  }

  void display() {                                    //display the chest
    image(image, xPos, yPos, sizeX, sizeY);
  }

  void rattle() {                             //let the chest rattle if you press on it by changing the x and y values 
    if (mousePressed) {
      if (mouseX > width/2+250-100 && mouseX < width/2+250+100 && mouseY > height-105-90 && mouseY <height-105+90) { 
        sizeX = int(random(200, 210));
        sizeY = int(random(180, 185));
      }
    } else {                        //else give it its initial size
      sizeX = 200;
      sizeY = 180;
    }
  }
}