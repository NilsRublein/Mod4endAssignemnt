// each of these subclasses of Screen
// defines one state of the statemachine

class State1 extends Screen {
  State1(ScreenState[] nextStates) {
    super(nextStates);
  }

  void draw() {
    PVector gravity = new PVector(0, 0.1*hook.fallingMass);         //let the hook sink
    hook.applyForce(gravity);                                    // Apply gravity
    flock.applyAttract(hook);                                      //apply attracting and repelling
    flock.applyRepel(hook);
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