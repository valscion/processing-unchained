import java.util.List;
import java.util.LinkedList;
AudioController audioController;
Player p = new Player(100, 100, 20,0);
Enemy e = new Enemy(500,400,20,20,5);
LinkedList<Enemy> enemies = new LinkedList<Enemy>();
int startTime = 0;

void setup() {
  size(1024, 500);
  background(50);


  // Alustetaan piirtomoodit, niin tiedetään miten asiat piirtyvät.
  // Näitä ei tule muuttaa myöhemmin!
  ellipseMode(CENTER);
  rectMode(CORNER);

  // Alustetaan audiojutut
  audioController = new AudioController();
  enemies.addLast(e);
  startGame();
}

void draw() {

  background(50);
    p.draw(4);
    this.goThroughEnemyList(enemies);
    audioController.draw();
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
