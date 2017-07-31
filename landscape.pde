//Use of perlin noise to generate random landscapes underwater every time the program is launched. 

class landscape {
  float yoff;            //the 2nd dimension of perlin noise 
  float ylow;            //lowest range for the random perlin noise
  float yhigh;           //largest range for the random perlin noise
  color colour;          //colour of the landscape

  //one constructor will allow to create multiple landscapes
  landscape(float ylowTemp, float yhighTemp, color colourTemp) {  //allow different generations of the size and colour of the landscape using the constructor
    yoff = 0;
    ylow = ylowTemp;          
    yhigh = yhighTemp;
    colour = colourTemp;
  }

  void display() {       //display function for the landscape
    fill(colour);
    beginShape();
    float xoff = 0;    // 2D Noise 

    // Iterate over horizontal pixels
    for (float x = 0; x <= width; x += 10) {
      // Calculate a y value according to noise, map to 
      float y = map(noise(xoff), 0, 1, ylow, yhigh);    // 1D Noise for a static landscape

      vertex(x, y);                                              // Set the vertex

      // Increment x dimension for noise
      xoff += 0.05;  //increment x values, to prevent a flat landscape
    }

    // increment y dimension for noise
    yoff += 0.01;
    vertex(width, height);
    vertex(0, height);             
    endShape(CLOSE);
  }
}