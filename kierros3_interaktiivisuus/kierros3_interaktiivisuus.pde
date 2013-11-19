AudioController audioController;
Player p = new Player(100, 100, 20,0);
Enemy e = new Enemy(500,400,20,20, 5);

void setup() {
  size(1024, 500);
  background(50);


  // Alustetaan piirtomoodit, niin tiedetään miten asiat piirtyvät.
  // Näitä ei tule muuttaa myöhemmin!
  ellipseMode(CENTER);
  rectMode(CORNER);

  // Alustetaan audiojutut
  audioController = new AudioController();
}

void draw() {

  background(50);
  //rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  if(checkEnemyPlayerCollision(e,p) == false){
  p.draw(5);
  e.draw();
  audioController.draw();
}
}

boolean checkEnemyPlayerCollision(Enemy e, Player p){

  int distanceX = abs(p.getX() - e.getX());
  int distanceY = abs(p.getY() - e.getY());

  if (distanceX > (e.width/2 + p.getR())) { return false; }
  if (distanceY > (e.height/2 + p.getR())) { return false; }

  if (distanceX <= (e.width/2)) { return true; }
  if (distanceY <= (e.height/2)) { return true; }

  float cornerDistance_sq = (distanceX - e.width/2)*(distanceX - e.width/2) +
    (distanceY - e.height/2)*(distanceY - e.height/2);

  return (cornerDistance_sq <= (p.getR()*p.getR()));
}
