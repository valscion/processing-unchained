import java.util.List;
import java.util.LinkedList;
import java.util.Map;
import java.util.HashMap;
AudioController audioController;
StateMachine stateMachine = new StateMachine();
Map<String, PFont> fonts = new HashMap<String, PFont>();

import ddf.minim.*;
Minim minim;

void setup() {
  size(1024, 500, P3D);
  try {
    minim = new Minim(this);

    audioController = new AudioController();

    fonts.put("size16", loadFont("Roboto-Medium-16.vlw"));
    fonts.put("size32", loadFont("Roboto-Medium-32.vlw"));
    fonts.put("size64", loadFont("Roboto-Medium-64.vlw"));

    stateMachine.addState(new GameState());
    stateMachine.addState(new CalibrateState());
    stateMachine.addState(new GameOverState());
    stateMachine.changeState(CalibrateState.class);
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