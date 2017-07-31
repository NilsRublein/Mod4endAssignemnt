//Class  for a seaGrass that contains a number of stems, stacked on each other

class seaPlant {
  int stemNumber = int (random(2, 5));
  Stem[] stem = new Stem[stemNumber];           //Create a number of stems
  PVector location;                             //location for each plant
  float waterStreamIncrement  = 0;              //set the initial value for the value that increments the water stream value to 0

  seaPlant(PVector _location) {                 //Constructor with location

    for (int i = 0; i < stem.length; i++) {
      stem[i] = new Stem(0, 20);                //initialize
    }

    location = _location.get();                 //get the location
  }

  void run() {                               //function that keeps track of displaying and the movement for each stem
    
    pushMatrix();
    translate(location.x, location.y);                        //initial origin

    float waterStreamNoise = noise(waterStreamIncrement);     //create a noise value that increments for the water stream
    float waterStream = map(waterStreamNoise, 0, 1, -1, 20);  //map this value and give it a wider range, this value will keep the plants softly moving
    waterStreamIncrement += 0.01;                             //increment!


    for (int i = 0; i < stem.length; i++) {
      stem[i].display();
      stem[i].move();
      stem[i].applyForce(waterStream);                       //apply the water stream to each stem
    }
    popMatrix();
  }
}