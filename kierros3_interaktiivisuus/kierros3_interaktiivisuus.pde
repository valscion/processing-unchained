AudioController audioController;

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
  rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);

  audioController.draw();
}
