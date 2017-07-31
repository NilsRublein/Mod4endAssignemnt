abstract class Screen {
  protected final ScreenState[] nextStates;

  private ScreenState nextState;

  Screen(ScreenState[] nextStates) {
    this.nextStates = nextStates;
  } 

  public boolean hasNextState() {
    return nextState != null;
  }

  public ScreenState getNextState() {
    return nextState;
  }

  public void enterState() {
    this.nextState = null;
  }

  protected abstract void draw();

  protected void handleKeyPress() {
  }

  protected void goToState(ScreenState nextState) {
    this.nextState = nextState;
  }
}