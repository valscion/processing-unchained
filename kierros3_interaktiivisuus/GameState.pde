class GameState extends State {
  Player p = new Player(100, 100, 20,0);
  LinkedList<Enemy> enemies = new LinkedList<Enemy>();
  int startTime = 0;
  int timeSinceLastEnemyAdded = 0;
  int timeBetweenNewEnemies = 2000;

  @Override
  void startState() {
    enemies.clear();
    startGame();
  }

  @Override
  void draw() {
    ellipseMode(CENTER);
    rectMode(CORNER);

    background(50);
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
      Enemy e = new Enemy(width, startY, 20, 20, 5);
      enemies.addLast(e);
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
          e.setInactive();
        }
      }
      e.draw();
    }
  }
}