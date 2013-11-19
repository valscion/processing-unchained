import java.util.List;
import java.util.LinkedList;
AudioController audioController;
Player p = new Player(100, 100, 20,0);
Enemy e = new Enemy(500,400,20,20,5);
LinkedList<Enemy> enemies = new LinkedList<Enemy>();

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
}

void draw() {

  background(50);
  //rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  p.draw(audioController.speed()*10);
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

void goThroughEnemyList(LinkedList l){
  for(int i = 0; i <l.size(); i ++){
    Enemy e = (Enemy) l.get(i);
    if(e.isActive()){
      if(this.checkEnemyPlayerCollision(e, this.p)){
        e.setInactive();
      }
    }
    e.draw();
  }
}
