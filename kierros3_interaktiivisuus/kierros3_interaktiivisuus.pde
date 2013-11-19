import java.util.List;
import java.util.LinkedList;
AudioController audioController;
StateMachine stateMachine = new StateMachine();

void setup() {
  try {
    size(1024, 500);
    background(50);


    // Alustetaan piirtomoodit, niin tiedetään miten asiat piirtyvät.
    // Näitä ei tule muuttaa myöhemmin!
    ellipseMode(CENTER);
    rectMode(CORNER);
    audioController = new AudioController();

    stateMachine.addState(new GameState());
    stateMachine.changeState(GameState.class);
    stateMachine.setup();
  }
  catch (Throwable t) {
    t.printStackTrace();
    exit();
  }
}

void draw() {
  utils.updateFPSTimer();
  //rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  stateMachine.draw();
}