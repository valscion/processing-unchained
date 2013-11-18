int rectX = 1024;
int rectY = round(random(this.height));
Player p = new Player(100, 100, 20,0);

void setup() {
  size(1024, 500);
  background(50);


  // Alustetaan piirtomoodit, niin tiedetään miten asiat piirtyvät.
  // Näitä ei tule muuttaa myöhemmin!
  ellipseMode(CENTER);
  rectMode(CORNER);
}

void draw() {
  background(50);
  /*
  rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  drawRect();*/
  fill(200);
  ellipse(p.x, p.y, 2*p.getR(), 2*p.getR());
}

void drawRect(){
  fill(200);
  rect(rectX, rectY, 50, 50);
  rectX = rectX-5;
  if(rectX < 0){
    rectX = width;
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
