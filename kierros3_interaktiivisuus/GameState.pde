class GameState extends State {
  Player p = new Player(100, 100, 20,0);
  Enemy e = new Enemy(500,400,20,20,5);
  LinkedList<Enemy> enemies = new LinkedList<Enemy>();
  int startTime = 0;

  @Override
  void startState() {
    enemies.addLast(e);
    startGame();
  }

  @Override
  void draw() {
    float playerSpeed = utils.pxPerSec(audioController.speed() * 500);
    p.draw(playerSpeed);
    this.goThroughEnemyList(enemies);
    audioController.update();
    audioController.drawDebug();
  }

  boolean checkEnemyPlayerCollision(Enemy e, Player p){

    float distanceX = abs(p.getX() - e.getX());
    float distanceY = abs(p.getY() - e.getY());

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

  void goThroughEnemyList(LinkedList l){
    for(int i = 0; i <l.size(); i ++){
      Enemy e = (Enemy) l.get(i);
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