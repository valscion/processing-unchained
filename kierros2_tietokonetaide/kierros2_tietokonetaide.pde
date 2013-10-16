PImage img;

void setup() {
  img = loadImage("hauska_kissakuva.jpg");
  size(img.width, img.height);

  noLoop();//paljon kevyempi jos on staattinen, kutsuu draw funktiota vain kerran
}

void draw() {
  PImage newGlitchPicture = pickRedColor(img);
  image(newGlitchPicture, 0, 0);
}

PImage pickRedColor(PImage im){
  im.loadPixels();
  int dimension = im.width * im.height;
  int alku = round(dimension*0.45);
  int loppu = round(dimension*0.62);

  for(int i = alku; i < loppu ; i++){
    color kaikkiaVareja = im.pixels[i];
    // Using "right shift" as a faster technique than red(), green(), and blue()
    color argb = kaikkiaVareja;
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    fill(r, g, b, a);

    color vainPunaista = color(r, 0, 0);
    im.pixels[i] = vainPunaista;
  }
  im.updatePixels();

  return im;
}
