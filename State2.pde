
// each of these subclasses of Screen
// defines one state of the statemachine

class State2 extends Screen {
  State2(ScreenState[] nextStates) {
    super(nextStates);
  }

  void draw() {
    PVector gravity = new PVector(0, -5*hook.fallingMass);          //reverse gravity
    hook.applyForce(gravity);

    if (hook.location.y > 10) {                        //only if the hook is higher than 10, apply attracting and repelling
      flock.applyAttract(hook);                                   
    flock.applyRepel(hook);
    }
    if (hook.location.y < -150) {
      gravity = new PVector(0, 0); 
      hook.applyForce(gravity);
      hook.location.set(width/2, -200 );
    }
  }


  void handleKeyPress() {
    // called by keyPressed() from main
    // conditional transition to a successor state - here with an interaction condition
    // also, here are two different possible successor states

    if (keyPressed) {
      goToState(nextStates[0]);
    } else {
      goToState(nextStates[1]);
    }
  }
}