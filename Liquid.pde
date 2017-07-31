//Example for liquid drag force from Daniel Shiffman, The Nature of Code, Chapter 2, Forces

class Liquid {
  
  // Liquid is a rectangle
  float x, y, w, h;
  // Coefficient of drag
  float c;

  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }

  // Is the Mover in the Liquid?
  boolean contains(Hook m) {                                 //Mover m changed to Hook (in comparison to Shiffman's example in the book)
    PVector l = m.location;
    if (l.x > x && l.x < x + w && l.y > y && l.y < y + h) {   //is the object in this liquid rectangle?
      return true;
    } else {
      return false;
    }
  }

  // Calculate drag force
  PVector drag(Hook m) {
    // Magnitude is coefficient * speed squared
    float speed = m.velocity.mag();
    float dragMagnitude = c * speed * speed;

    // Direction is inverse of velocity
    PVector dragForce = m.velocity.get();
    dragForce.mult(-1);

    // Scale according to magnitude
    // dragForce.setMag(dragMagnitude);
    dragForce.normalize();
    dragForce.mult(dragMagnitude);
    return dragForce;
  }
}