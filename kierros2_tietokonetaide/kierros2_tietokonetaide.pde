PImage img;

/*
Kun metodeissa on parametrinä kuva voidaan myöhemmin käyttää useammilla kuvilla
samoja metodeja samanaikaisesti, kun tätä laajennetaan käyttäjän valitsemiin
kuviin.

Ohjelma on vielä staattinen, eli draw metodia kutsutaan vain kerran.
*/

void setup() {
  //ladataan ensimmäisessä versiossa oletuskuva
  img = loadImage("hauska_kissakuva.jpg");
  //luodaan ikkunasta sen kuvan kokoinen
  size(img.width, img.height);
  //staattinen tässä vaiheessa, eli draw piirtyy vain kerran
  noLoop();
}

void draw() {
    /*
  Tässä metodissa kutsutaan aina edellisellä kuvalla uutta metodia. Esimerkiksi
  on kirjoitettu makeRedGlitch-metodi, jota kutsutaan valitulla (nyt oletus-)
  kuvalla
  */
  PImage redGlitch = makeRedGlitch(img);
  //PImage jokuMuuGlitsi = jokuMuuGlitsiMetodi(redGlitch);
  //...
  //...

  //tässä piirretään viimeisin kuva näytölle
  image(redGlitch, 0, 0);
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
