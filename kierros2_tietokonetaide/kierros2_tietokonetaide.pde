import javax.swing.*;
PImage org;
PImage img;
int clicks;
/*
Kun metodeissa on parametrinä kuva voidaan myöhemmin käyttää useammilla kuvilla
samoja metodeja samanaikaisesti, kun tätä laajennetaan käyttäjän valitsemiin
kuviin.

Kuvan voi itse valita (oletuksena hauska_kissakuva.jpg) ja ikkuna muuttuu kuvan
mukaan. Käyttäjän hiiren klikkaukset glitchaavat kuvaa. Näppäimellä ohjelma 
kysyy uutta kuvaa. 

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
    //vähän omia lisailyja
    if (file.getName().endsWith("jpg") || file.getName().endsWith("gif") || file.getName().endsWith("png")) {
      // load the image using the given file path
      org = loadImage(file.getPath());
      img = loadImage(file.getPath());
    }
  } else {
    //oletuksena vähemmän hauska kissakuva
    org = loadImage("hauska_kissakuva.jpg");
    img = loadImage("hauska_kissakuva.jpg");
  }

  //luodaan ikkunasta sen kuvan kokoinen
  size(org.width, org.height);
  if (frame != null) {
    frame.setResizable(true);//täytyy olla size:n jälkeen
    frame.setSize(org.width+16, org.height+38);//jostain syystä heittää aina defaulttina 16 px vaakaa ja 38 pystyä, win7 ikkunalla ainakin
  }
  clicks = 0;
}

void draw(){
  image(img, 0,0);
  if(millis()< 20000){
    int textTime = (20000 - millis()) / 1000;
    text("Tämä teksti katoaa "+textTime+" sekunnin kuluttua. \n"+
      "Painamalla näppäintä voit valita uuden kuvan. \n"+
      "Klikkaamalla hiirellä kuvaan ilmestyy häiriötä.", 10, 20);
  }
}


void glitchify(int x, int y) {
  //metodeissa muutetaan img kuvaa, ja ne saavat parametreikseen img
  //hiiren klikkauksen mukaan tehdään vuorollaan eri asioita
  switch (clicks){
    case 0: img = colorTransfer(img, x, y); break;
    case 1: img = makeVertShift(img); break;
    case 2: img = img = makeFiltering(img); break;
    default: {
      int rand = round(random(80));
      for (int i = 0; i < rand; i++) {
        img = mergePixels(img);
      }
      break;
    }
  }
  //tässä piirretään muokattu kuva näytölle
  image(img, 0, 0);
  clicks++;
}

void mousePressed() {
  glitchify(mouseX, mouseY);
}

void keyPressed() {
  setup();
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

//Tutkii mitä värejä kuvan perusteella kannattaisi siirtää, parametreilla määrätään väri, arvoina voi antaa 0, 255 tai keltaisen tapauksessa 127 kahdelle
boolean isEnoughColorToTransfer(PImage im, int partR, int partG, int partB){
  int dimension = im.width * im.height;
  int numberOfThatColor = 0;
  //käy läpi kuvan etsien haluttua väriä
  for(int i = 0; i < dimension; i++){
    color argb = im.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;
    int g = (argb >> 8) & 0xFF;
    int b = argb & 0xFF;
    //punainen
    if( partR == 255 && r > g+20 && r > b+20 
      ||partG == 255 && g > b+5 && g > r+5
      ||partB == 255 && b > r+20 && b > g+20
      ||partR == 127 && partG == 127 && r > b+50 && g > b+50){
      numberOfThatColor++;
    }
  }
  if(numberOfThatColor > dimension*0.15 && numberOfThatColor < dimension*0.6) return true;
  if(partR == 255 && numberOfThatColor > dimension*0.05 && numberOfThatColor < dimension*0.5) return true;
  else return false;
}

PImage colorTransfer(PImage im, int x, int y){
  PImage part = im.get(0, 0, width, height);
  int dimension = part.width * part.height;
  part.loadPixels();
  //hiiren x:n mukaan siirtää kuvan keskikohdan suhteen sivusuunnassa
  int deltaX = (part.width/2)-x;
  int deltaY = 1;//vain yksi rivi ylöspäin oletuksena, 
  while(deltaY*part.width <= deltaX) deltaY++;//mutta joissain tapauksissa tarvitaan enemmän. 
  int redTransfer    = deltaX   + deltaY*  part.width;
  int yellowTransfer = deltaX/2 + deltaY*2*part.width;
  int blueTransfer   = deltaX/4 + deltaY*  part.width;
  float occupation = 0.4;

  //pohtii mitä värejä kuvan perusteella kannattaisi siirtää
  boolean isRedTransfer = isEnoughColorToTransfer(im, 255,0,0);
  boolean isGreenTransfer = isEnoughColorToTransfer(im, 0,255,0);
  boolean isYellowTransfer = isEnoughColorToTransfer(im, 127,127,0);
  boolean isBlueTransfer = isEnoughColorToTransfer(im, 0,0,255);
  if(!isRedTransfer && !isGreenTransfer && !isYellowTransfer && !isBlueTransfer){//joka tapauksessa edes joku siirtyy
    isRedTransfer= true;
    isYellowTransfer = true;
  } 

  //käy pikselit läpi
  for(int i = 0; i < dimension; i++){
    color argb = part.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;
    int g = (argb >> 8) & 0xFF;
    int b = argb & 0xFF;

    if(i-redTransfer > 0 && i-yellowTransfer > 0 && i-blueTransfer > 0){
      //punainen
      if(isRedTransfer && r > g+20 && r > b+20){
        color strongColor = color(r, 0,0); //muodostetaan haluttu uusi väri
        color targetPxColor = part.pixels[i - redTransfer]; //haetaan kohteesta sen väri
        part.pixels[i - redTransfer] = lerpColor(strongColor, targetPxColor, occupation);//tasoittaa uuden ja vanhan pikselin värit = läpinäkyvyyttä siirtoon
        part.pixels[i] = color((g+b)/2, g, b);//"heikentää" väriä joka "poistetaan"/"siirretään";
      }
      //vihreä
      if(isGreenTransfer && g > b+5 && g > r+5){
        color strongColor = color(0, g, 0);
        color targetPxColor = part.pixels[i - yellowTransfer];
        part.pixels[i - yellowTransfer] =  lerpColor(strongColor,targetPxColor, occupation);
        part.pixels[i] = color(r,(r+b)/2, b);
      }
      //keltainen
      if(isYellowTransfer && r > b+50 && g > b+50){
        color strongColor = color(r, g, 0);
        color targetPxColor = part.pixels[i - yellowTransfer];
        part.pixels[i - yellowTransfer] = lerpColor(strongColor, targetPxColor, occupation);
        part.pixels[i] = color(b, b, b);
      }
      //sininen
      if(isBlueTransfer && b > r+20 && b > g+20){
        color strongColor = color(0, 0, b);
        color targetPxColor = part.pixels[i - blueTransfer];
        part.pixels[i - blueTransfer] = lerpColor(strongColor, targetPxColor, occupation);
        part.pixels[i] = color(r, g,(g+r)/2);
      }
    }
  }
  part.updatePixels();
  im = part;
  return im;
}
