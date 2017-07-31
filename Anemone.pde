//Via use of inheritance we extend this class to the original seaPlant class (take over functions, etc)
//Is used now for anemone plant instead of the grass 

class Anemone extends seaPlant {
  int stemNumber = int(random(3, 6));                        //give it a different number of stems!
  AnemoneStem[] anemoneStem = new AnemoneStem[stemNumber];

  Anemone(PVector _location) {
    super(_location);


    for (int i = 0; i < anemoneStem.length; i++) {
      anemoneStem[i] = new AnemoneStem(0, 80);                //give them a longer length by changing the rotation point / origin
    }
  }

  void run() {                                       //keeps track of displaying and movements
    pushMatrix();
    translate(location.x, location.y);               //initial origin

    float waterStreamNoise = noise(waterStreamIncrement);        //again, increment a noise value for the waterstream
    float waterStream = map(waterStreamNoise, 0, 1, -1, 20);     //and map it to give it a more suitable range
    waterStreamIncrement += 0.01;


    for (int i = 0; i < anemoneStem.length; i++) {              //display, move and apply the water stream force for each stem
      anemoneStem[i].display();
      anemoneStem[i].move();
      anemoneStem[i].applyForce(waterStream);
    }
    popMatrix();
  }
}