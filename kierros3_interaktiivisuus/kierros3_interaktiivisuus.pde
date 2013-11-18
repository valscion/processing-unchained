int rectX = 1024;
int rectY = round(random(this.height));

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
rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  drawRect();
}
void drawRect(){
  fill(200);
  rect(rectX, rectY, 50, 50);
  rectX = rectX-5;
  if(rectX < 0){
    rectX = width;
  }
}
