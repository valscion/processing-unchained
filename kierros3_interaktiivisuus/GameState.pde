import ddf.minim.AudioPlayer;

class GameState extends State {
  Player p = new Player(100, 100, 25,0);
  LinkedList<Enemy> enemies = new LinkedList<Enemy>();
  int startTime = 0;
  int timeSinceLastEnemyAdded = 0;
  int timeBetweenNewEnemies = 1000;
  EffectSystem effects = new EffectSystem();
  AudioPlayer player = minim.loadFile("game_13.mp3");
  BackgroundPicture bgp;
  PImage pic;

  @Override
  void startState() {
    enemies.clear();
    p.lives = 10;
    player.rewind();
    player.loop();
    startGame();
    bgp  = new BackgroundPicture();
    pic = loadImage("asteroid.png");

  }

  @Override
  void endState() {
    player.pause();
  }

  @Override
  void draw() {
    background(50);
    textFont(fonts.get("size16"), 20);
    text("Lives: " + p.lives, width/20, 50);
    effects.draw();
    ellipseMode(CENTER);
    rectMode(CORNER);
    bgp.draw();


    if (audioController.isSoundLoudEnough()) {
      float playerSpeed = utils.pxPerSec(audioController.soundValue());
      p.setSpeed(playerSpeed);
    }
    p.draw();
    this.addEnemiesIfNeeded();
    this.goThroughEnemyList(enemies);
    audioController.update();
    //audioController.drawDebug();
  }

  boolean checkEnemyPlayerCollision(Enemy e, Player p){

    float distanceX = abs(p.getX() - p.getR() - e.getX());
    float distanceY = abs(p.getY() - p.getR() - e.getY());

    if (distanceX > (e.width/2 + p.getR())) { return false; }
    if (distanceY > (e.height/2 + p.getR())) { return false; }

    if (distanceX <= (e.width/2)) { return true; }
    if (distanceY <= (e.height/2)) { return true; }

    float cornerDistance_sq = (distanceX - e.width/2)*(distanceX - e.width/2) +
      (distanceY - e.height/2)*(distanceY - e.height/2);

    return (cornerDistance_sq <= (p.getR()*p.getR()));
  }
  void startGame(){
    startTime = millis();
  }
  int gameTime(){
    return millis() -startTime;
  }

  void addEnemiesIfNeeded() {
    int diff = millis() - timeSinceLastEnemyAdded;
    if (diff > timeBetweenNewEnemies) {
      timeSinceLastEnemyAdded = millis();
      float startY = random(0, height - 20);
      Enemy e = new Enemy(width, startY, 20, 20, 5,pic);
      enemies.addLast(e);
      effects.onNewEnemy(e);
    }
  }

  void goThroughEnemyList(List<Enemy> enemyList){
    Iterator<Enemy> iter = enemyList.iterator();
    while (iter.hasNext()) {
      Enemy e = iter.next();
      if(e.isActive()){
        if(gameTime() < 10000){
          e.setSpeed(2);
        }
        else if(gameTime() < 20000){
          e.setSpeed(4);
        }
        else if(gameTime() < 30000){
          e.setSpeed(6);
        }
        else if(gameTime() < 40000){
          e.setSpeed(10);
        }
        if(this.checkEnemyPlayerCollision(e, this.p)){
          effects.onPlayerHit(e, this.p);
          e.setInactive();
          this.p.enemyHit();
          if(this.p.lives == 0){
            stateMachine.changeState(GameOverState.class);
          }
        }
      }
      e.draw();
    }
  }
}
