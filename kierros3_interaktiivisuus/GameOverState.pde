class GameOverState extends State{
   GameState game = (GameState) stateMachine.getState(GameState.class);
   String survivalTime;

  @Override
  void draw(){
    background(0);
    fill(255);
    textAlign(CENTER, TOP);
    textFont(fonts.get("size64"), 64);
    text("Game over", width/2, 10);
    textFont(fonts.get("size16"), 16);
    text("You survived "+ survivalTime + " seconds" , width/2, 120);
    text("Press ENTER to try again", width/2, 150);
    text("Press C to re-calibrate", width/2, 180);

    if (keyPressed) {
      if (key == 'c' || key == 'C') {
        stateMachine.changeState(CalibrateState.class);
      }
      else if (key == KeyEvent.VK_ENTER) {
        stateMachine.changeState(GameState.class);
      }
    }
  }
  @Override
  void startState(){
    int survivedMs = game.gameTime();
    survivalTime = String.format("%.3f", survivedMs/1000.0);
  }
}