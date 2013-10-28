import javax.swing.*;
PImage org;
PImage img;

/*
Kun metodeissa on parametrinä kuva voidaan myöhemmin käyttää useammilla kuvilla
samoja metodeja samanaikaisesti, kun tätä laajennetaan käyttäjän valitsemiin
kuviin.

Ohjelma on vielä staattinen, eli draw metodia kutsutaan vain kerran per kuva.
Kuvan voi itse valita (oletuksena hauska_kissakuva.jpg) ja ikkuna muuttuu kuvan
mukaan.

Hyödynnetty valmista tiedoston valitsijaa:
http://processinghacks.com/hacks:filechooser
@author Tom Carden
*/

void setup() {

  //------- tästä alkaa ulkopuolinen filechooser-koodi
  // set system look and feel
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } catch (Exception e) {
    e.printStackTrace();
  }
  // create a file chooser
  final JFileChooser fc = new JFileChooser();
  // in response to a button click:
  int returnVal = fc.showOpenDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    // see if it's an image
    if (file.getName().endsWith("jpg")) {
      // load the image using the given file path
      org = loadImage(file.getPath());
    }
    //-------tähän loppuu ulkopuolinen koodi
    else if(file.getName().endsWith("gif")) {
      org = loadImage(file.getPath());
    }
    else if(file.getName().endsWith("png")){
      org = loadImage(file.getPath());
    }
    //tähän voi lisäillä muutamia Processingin tukemia muotoja kunhan joutaa
  } else {
    //oletuksena vähemmän hauska kissakuva
    org = loadImage("hauska_kissakuva.jpg");
  }

  //luodaan ikkunasta sen kuvan kokoinen
  size(org.width, org.height);
  if (frame != null) {
    frame.setResizable(true);//täytyy olla size:n jälkeen
    frame.setSize(org.width, org.height);//täytyy olla "uudestaan" koska edellisen arvon täytyy olla true
  }
  //staattinen tässä vaiheessa, eli draw piirtyy vain kerran per kuva
  noLoop();
}

void draw() {
  //muutettava img alustetaan org kuvalla
  img = org;
  //metodeissa muutetaan img kuvaa, ja ne saavat parametreikseen img
  //img = makeRedGlitch(img);
  img = makeGreenishStaticNoise(img);
  img = colorTransfer(img);
  //img = makeVertShift(img);
  img = makeFiltering(img);
  img = makeVertShift(img);
  int rand = round(random(80));
  for (int i = 0; i < rand; i++) {
      img = mergePixels(img);
  }
  //img = makeVertShift(img);

  //tässä piirretään muokattu kuva näytölle
  image(img, 0, 0);
}

void mousePressed() {
  setup();
}

void keyPressed() {
  draw();
  //saveScreenshot();
}

//tallentaa kuvankaappauksen identioituna millisekuntteina screenshots kansioon
void saveScreenshot(){
  float identikaatio = millis();
  String nimi = "screenshots/screenshot_"+identikaatio+".jpg";
  save(nimi);
}
PImage makeFiltering(PImage im){
  int randomX = round(random(width));
  int randomY = round(random(height));
  PImage newPic = im.get(0,randomY,width,randomY);
  image(im,0,0);
  newPic.filter(INVERT);
  image(newPic, 0, randomY);
  im=get(0,0, width, height);
  return im;
}

/*metodit palauttavat aina kuvan, jotta globaaleja muuttujia ei luoda kaikille,
tai ohjelman ainut versio kuvasta ei tuhoudu*/
PImage makeRedGlitch(PImage im){
  int dimension = im.width * im.height;
  int alku = round(dimension*0.45);
  int loppu = round(dimension*0.62);

  //kutsutaan im-kuvan pikselit pixels-listaan
  im.loadPixels();

  //for-looppi käy vain osan pikseleistä läpi (45%-62% väliltä, aiemmin määritelty)
  for(int i = alku; i < loppu ; i++){
    //lukee pikselin värin ja tallentaa sen muuttujaan
    color argb = im.pixels[i];
    //suoraan esimerkistä
    //http://processing.org/reference/rightshift.html
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    //=> Saadaan jokainen väriarvo erikseen
    //niillä voi sitten leikkiä mielensä mukaan
    color vainPunaista = color(r, g*0.9, b*0.9);//tummennetaan muita -> punertuu
    if(g < 100 && b < 100){
      vainPunaista = color(r, 0, 0);
    }
    //pikseliksi talletetaankin tämä muutettu väri
    im.pixels[i] = vainPunaista;
  }
  //päivitetään lista muutetuista pikseleistä takaisin kuvaksi
  im.updatePixels();
  //palautetaan kuva
  return im;
}

/*
PImage jokuMuuGlitsiMetodi(PImage im){
  int dimension = im.width * im.height;
  int alku = round(dimension*0.8);
  int loppu = round(dimension*0.82);
  im.loadPixels();
  for(int i = alku; i < loppu ; i++){
    color argb = im.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    color vainKeltaista = color(r, g, 0);
    im.pixels[i] = vainKeltaista;
  }
  im.updatePixels();
  return im;
}
*/

PImage makeGreenishStaticNoise(PImage im){
  int dimension = im.width * im.height;
  int alku = round(dimension*0.1);
  int loppu = round(dimension*0.2);
  im.loadPixels();
  for(int i = alku; i < loppu ; i++){
    color argb = im.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)

    float randValue = random(0,1);
    if(randValue > 0.9){
      r = 0;
      g = 255;
      b = 255;
    }
    else if(randValue > 0.5 && randValue < 0.6){
      r = 255;
      g = 255;
      b = 0;
    }
    else if(randValue > 0.0 && randValue < 0.1){
      r = 0;
      g = 255;
      b = 0;
    }
    color alteredColor = color(r, g, b);
    im.pixels[i] = alteredColor;
  }
  im.updatePixels();
  return im;
}
PImage makeVertShift(PImage im) {
  im.loadPixels();
    for (int k = 0; k<im.height; k++) {
      for (int j = 0; j < im.width; j++) {
        color origPixel = im.pixels[k*im.width+j];
        if (j <= k) {
          im.pixels[(k)*im.width-(k-j)] = origPixel;
        }
        else {
          im.pixels[k*im.width+j-k] = origPixel;
        }
      }
    }
  im.updatePixels();
  return im;
}

PImage mergePixels(PImage im) {
  float x = random(im.width);
  float y = random(im.height);
  color c = im.get(int(x), int(y));
  fill(c);
  noStroke();
  float pixelSize = random(50);
  image(im,0,0);
  rect(x, y, pixelSize, pixelSize);
  im=get(0,0, width, height);
  return im;
}

PImage colorTransfer(PImage im){
  //int rand1 = int(random(0, im.width-100));
  //int rand2 = int(random(0, im.height-100));
  //int rand3 = int(random(0, im.width-rand1));
  //int rand4 = int(random(0, im.height-rand2));
  PImage part = im.get(0, 0, width, height);

  int dimension = part.width * part.height;

  part.loadPixels();
  int siirtyma1 = -50 + 1*part.width;
  int siirtyma2 = -20 + 12*part.width;
  int siirtyma3 = 1 + 75*part.width;
  float vahvuus1 = 0.4;

  for(int i = 0; i < dimension; i++){
    color argb = part.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)

    if(i-siirtyma1 > 0 && i-siirtyma2 > 0 && i-siirtyma3 > 0){
      if(r > g+20 && r > b+20){
        color vain = color(r*1.5, 0,0);
        color vieresta = part.pixels[i - siirtyma1];
        part.pixels[i - siirtyma1] = lerpColor(vain, part.pixels[i - siirtyma1], vahvuus1);
      }
      else if(g > b+2 && g > r+2){
        color vain = color(0, g, 0);
        color vieresta = part.pixels[i - siirtyma2];
        part.pixels[i - siirtyma2] =  lerpColor(vain, part.pixels[i - siirtyma2], vahvuus1);
      }
      else if(b > r+20 && b > g+20){
        color vain = color(0, 0, b);
        color vieresta = part.pixels[i - siirtyma3];
        part.pixels[i - siirtyma3] = lerpColor(vain, part.pixels[i - siirtyma3], vahvuus1);
      }
    }
  }
  part.updatePixels();
  im = part;
  return im;
}
