import javax.swing.*;
PImage org;
PImage img;
int clicks;
boolean glitched;
int currentPic;
/*
Kun metodeissa on parametrinä kuva voidaan myöhemmin käyttää useammilla kuvilla
 samoja metodeja samanaikaisesti, kun tätä laajennetaan käyttäjän valitsemiin
 kuviin.

 Kuvan voi itse valita (oletuksena hauska_kissakuva.jpg) ja ikkuna muuttuu kuvan
 mukaan. Käyttäjän hiiren klikkaukset glitchaavat kuvaa. Näppäimellä ohjelma
 kysyy uutta kuvaa.

 Hyödynnetty valmista tiedoston valitsijaa askForImageMetodissa:
 http://processinghacks.com/hacks:filechooser
 @author Tom Carden
 */

void setup() {
  currentPic = 1;
  frameRate(30);
  img = askForImage();
  setupWithPicture(img);
}

void setupWithPicture(PImage im){
  img = im;
  org = im;
  //luodaan ikkunasta sen kuvan kokoinen
  size(img.width, img.height);
  if (frame != null) {
    frame.setResizable(true);//täytyy olla size:n jälkeen
    frame.setSize(img.width+16, img.height+38);//jostain syystä heittää aina defaulttina 16 px vaakaa ja 38 pystyä, win7 ikkunalla ainakin
  }
  glitched = true;
  clicks = 0;
}

PImage askForImage(){
  //filechooser koodi on hieman muokattuna tässä metodissa
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  }
  catch (Exception e) {
    e.printStackTrace();
  }
  final JFileChooser fc = new JFileChooser();
  int returnVal = fc.showOpenDialog(this);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    if (file.getName().endsWith("jpg") || file.getName().endsWith("gif") || file.getName().endsWith("png")) {
      org = loadImage(file.getPath());
    }
  }
  else {
    //oletuksena kissakuva
    org = loadImage("example"+currentPic+".jpg");
  }
  return org;
}

void draw() {
  glitchifyLoop(mouseX, mouseY);
  image(img, 0, 0);
  if (millis()< 25000) {
    int textTime = (25000 - millis()) / 1000;
    text("Tämä ohje katoaa "+textTime+" sekunnin kuluttua. \n"+
      "Painamalla nuolta ylöspäin saat uuden esimerkkikuvan. \n"+
      "Painamalla nuolta vasemmalle ohjelma tallentaa kuvankaappauksen screenshots-kansioon. \n"+
      "Painamalla jotain muuta näppäintä voit valita uuden kuvan itse. \n"+
      "Klikkaamalla hiirellä kuvaan ilmestyy uusi häiriö.", 10, 20);
  }
}

void glitchify(int x, int y) {
  //metodeissa muutetaan img kuvaa, ja ne saavat parametreikseen img
  //hiiren klikkauksen mukaan tehdään vuorollaan eri asioita
  switch (clicks) {
  case 0:
    img = colorTransfer(img, x, y);
    break;
  case 1:
    img = makeVertShift(mouseX, mouseY);
    break;
  case 2:
    img = img = makeFiltering(img);
    break;
  default:
    {
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

void glitchifyLoop(int x, int y) {
  img = org.get();
  switch (clicks) {
  case 1:
    img = colorTransfer(img, x, y);
    break;
  case 2:
    img = makeVertShift(mouseX, mouseY);
    break;
  case 3:
    img = makeFiltering(img);
    break;
  case 4:
    img = mergePixels(img);
    break;
  }
}

void mousePressed() {
  // glitchify(mouseX, mouseY);
  clicks++;
}

void keyPressed() {
  if(keyCode == UP){
    switchExamplePicture();
  }
  else if(keyCode == LEFT){
    saveScreenshot();
  }
  else{
    setup();
  }
}

void switchExamplePicture(){
  boolean isOld = true;
  while(isOld){
    currentPic++;
    if(currentPic > 0 && currentPic <= 6){
      PImage nextExample = loadImage("example"+currentPic+".jpg");
      setupWithPicture(nextExample);
      isOld = false;
    }
    else{
      currentPic = 0;
    }
  }
}

int glitchTime = 250;
int millisAtLastTrue = 0;
/*
Antaa booleanin riippuen siitä onko satunnainen aika 100-1000 ms välillä kulunut
*/
boolean isItTime(){
  if(millis()-millisAtLastTrue < glitchTime){
    return false;
  }
  else{
  int randTimePeriod = int(random(100, 1000));
  glitchTime = randTimePeriod;
  millisAtLastTrue = millis();
  return true;
  }
}

//tallentaa kuvankaappauksen identioituna millisekuntteina screenshots kansioon
void saveScreenshot() {
  float identikaatio = millis();
  String nimi = "screenshots/screenshot_"+identikaatio+".jpg";
  save(nimi);
}

PImage makeFiltering(PImage im) {
  int randomX = round(random(width));
  int randomY = round(random(height));
  int randomZ = round(random(100));
  PImage newPic = im.get(0, randomY, width, randomY);
  image(im, 0, 0);
  if(randomZ < 25){
  newPic.filter(INVERT);
  }
  else if(randomZ < 50){
    newPic.filter(THRESHOLD);
  }
  else if(randomZ < 75){
    newPic.filter(POSTERIZE, 4);
  }
  else{
    newPic.filter(GRAY);
  }
  image(newPic, 0, randomY);
  im=get(0, 0, width, height);
  return im;
}

PImage makeVertShift(int x, int y) {
 PImage copy = org.get();
 copy.loadPixels();

<<<<<<< HEAD
    int c = y-(copy.width-x);
 if( c <= 0){
  if(y+x < copy.height){
   
    for (int k =x+y ; k>=0; k--) {
=======
    for (int k = 0; k<copy.height; k++) {
>>>>>>> 05815aba7002882ac859493dbca96cf8dc927b21
      for (int j = 0; j < copy.width; j++) {
        color origPixel = copy.pixels[k*copy.width+j];
          copy.pixels[k*copy.width+j-(k-x-y)] = origPixel;
      }
    } 
    
  }
 }
 else{

    for (int k =c ; k<copy.height; k++) {
      for (int j = 0; j < copy.width; j++) {
        color origPixel = copy.pixels[k*copy.width+j];
          copy.pixels[k*copy.width+j-(k-c)] = origPixel;
      }
    } 
 }


  copy.updatePixels();

  return copy;
}


PImage mergePixels(PImage im) {
  float x = random(im.width);
  float y = random(im.height);
  color c = im.get(int(x), int(y));
  fill(c);
  noStroke();
  float pixelSize = random(50);
  image(im, 0, 0);
  rect(x, y, pixelSize, pixelSize);
  im=get(0, 0, width, height);
  return im;
}

//Tutkii mitä värejä kuvan perusteella kannattaisi siirtää, parametreilla määrätään väri, arvoina voi antaa 0, 255 tai keltaisen tapauksessa 127 kahdelle
boolean isEnoughColorToTransfer(PImage im, int partR, int partG, int partB) {
  int dimension = im.width * im.height;
  int numberOfThatColor = 0;
  //käy läpi kuvan etsien haluttua väriä
  for (int i = 0; i < dimension; i++) {
    color argb = im.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;
    int g = (argb >> 8) & 0xFF;
    int b = argb & 0xFF;
    if ( partR == 255 && r > g+20 && r > b+20
      ||partG == 255 && g > b+5 && g > r+5
      ||partB == 255 && b > r+20 && b > g+20
      ||partR == 127 && partG == 127 && r > b+50 && g > b+50) {
      numberOfThatColor++;
    }
  }
  if (numberOfThatColor > dimension*0.05 && numberOfThatColor < dimension*0.8) return true;
  if (partR == 255 && numberOfThatColor > dimension*0.01 && numberOfThatColor < dimension*0.5) return true;
  else return false;
}

PImage colorTransfer(PImage im, int x, int y) {
  PImage part = im.get(0, 0, width, height);
  int dimension = part.width * part.height;
  part.loadPixels();
  //hiiren x:n mukaan siirtää kuvan keskikohdan suhteen sivusuunnassa
  int deltaX = (part.width/2)-x;
  int deltaY = 1;//vain yksi rivi ylöspäin oletuksena,
  while (deltaY*part.width <= deltaX) deltaY++;//mutta joissain tapauksissa tarvitaan enemmän.
  int redTransfer    = int(deltaX   + deltaY*  part.width);//+part.width*part.height*0.5);
  int yellowTransfer = int(deltaX/1.1 + deltaY*2*part.width);//+part.width*part.height*0.5);
  int blueTransfer   =int(deltaX/4 + deltaY*  part.width);//+part.width*part.height*0.5);
  int greenTransfer  =int(deltaX/6 + deltaY*3*part.width);//+part.width*part.height*0.5);
  float occupation = 0.4;

  //pohtii mitä värejä kuvan perusteella kannattaisi siirtää
  boolean isRedTransfer = isEnoughColorToTransfer(im, 255, 0, 0);
  boolean isGreenTransfer = isEnoughColorToTransfer(im, 0, 255, 0);
  boolean isYellowTransfer = isEnoughColorToTransfer(im, 127, 127, 0);
  boolean isBlueTransfer = isEnoughColorToTransfer(im, 0, 0, 255);
  if (!isRedTransfer && !isGreenTransfer && !isYellowTransfer && !isBlueTransfer) {//joka tapauksessa edes joku siirtyy
    isRedTransfer= true;
    isYellowTransfer = true;
  }

  //käy pikselit läpi
  for (int i = 0; i < dimension; i++) {
    color argb = part.pixels[i];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;
    int g = (argb >> 8) & 0xFF;
    int b = argb & 0xFF;

    if (i-redTransfer > 0 && i-yellowTransfer > 0 && i-blueTransfer > 0 && i-greenTransfer > 0) {
      //punainen
      if (isRedTransfer && r > g+20 && r > b+20) {
        color strongColor = color(r, 0, 0);//(255, 75, 132);// //muodostetaan haluttu uusi väri
        color targetPxColor = part.pixels[i - redTransfer]; //haetaan kohteesta sen väri
        part.pixels[i - redTransfer] = lerpColor(strongColor, targetPxColor, occupation);//tasoittaa uuden ja vanhan pikselin värit = läpinäkyvyyttä siirtoon
        part.pixels[i] = color((g+b)/2, g, b);//"heikentää" väriä joka "poistetaan"/"siirretään";
      }
      //vihreä
      if (isGreenTransfer && g > b+5 && g > r+5) {
        color strongColor = color(0, g, 0);//(125, 241, 255);
        color targetPxColor = part.pixels[i - greenTransfer];
        part.pixels[i - greenTransfer] =  lerpColor(strongColor, targetPxColor, occupation);
        part.pixels[i] = color(r, (r+b)/2, b);
      }
      //keltainen
      if (isYellowTransfer && r > b+50 && g > b+50) {
        color strongColor = color(r, g, 0);
        color targetPxColor = part.pixels[i - yellowTransfer];
        part.pixels[i - yellowTransfer] = lerpColor(strongColor, targetPxColor, occupation);
        part.pixels[i] = color(b, b, b);
      }
      //sininen
      if (isBlueTransfer && b > r+20 && b > g+20) {
        color strongColor = color(0, 0, b);
        color targetPxColor = part.pixels[i - blueTransfer];
        part.pixels[i - blueTransfer] = lerpColor(strongColor, targetPxColor, occupation);
        part.pixels[i] = color(r, g, (g+r)/2);
      }
    }
  }
  part.updatePixels();
  im = part;
  return im;
}
