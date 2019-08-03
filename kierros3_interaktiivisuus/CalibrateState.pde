import java.awt.event.KeyEvent;

// This state is used to calibrate the sound level
class CalibrateState extends State {
  private int timeWhenLimitSet = 0;

  @Override
  void draw() {
    ellipseMode(CENTER);

    background(0);
    fill(255);
    textAlign(CENTER, TOP);
    textFont(fonts.get("size64"), 64);
    text("Calibrate your microphone", width/2, 10);
    textFont(fonts.get("size16"), 16);
    text("When the circle below turns RED, it means your", width/2, 120);
    text("voice is loud enough and it is registered.", width/2, 150);
    text("To setup the limit to your current volume,", width/2, 200);
    text("hit the SPACE key. When you're done,", width/2, 230);
    text("start the game by pressing ENTER", width/2, 260);

    float timeDiff = millis() - timeWhenLimitSet;
    if (timeWhenLimitSet > 0 && timeDiff < 1500) {
      float mappedValue = map(timeDiff, 1500, 0, 0, 1);
      fill(mappedValue * 255);
      textFont(fonts.get("size32"), 32);
      text("SOUND LEVEL SET", width/2, 300);
    }

    if (audioController.isSoundLoudEnough()) {
      fill(216, 0, 0);
    }
    else {
      fill(0, 216, 0);
    }

    ellipse(width/2, 400, 100, 100);

    float soundVolume = audioController.getCurrentSoundVolume();

    textFont(fonts.get("size16"), 16);
    text("Volume now", width/2, 450);
    text(soundVolume, width/2, 466);
    text("Current limit: " + audioController.getSoundLimit(), width/2, 482);

    if (keyPressed) {
      if (key == ' ') {
        audioController.setSoundLimit(soundVolume);
        timeWhenLimitSet = millis();
      }
      else if (key == KeyEvent.VK_ENTER) {
        stateMachine.changeState(GameState.class);
      }
    }
  }
}
