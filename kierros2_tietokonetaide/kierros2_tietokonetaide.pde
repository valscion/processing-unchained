float randPituus;
float randKulma;
float randKulmaKeskimmaiselle;
float kultainenXoik;
float kultainenYylempi;
float kultainenXvas;
float kultainenYalempi;
float kultainenleikkaus = 0.618;
int aika1 = 4000;
int aika2 = 12000;
int aika3 = 20000;

void setup() {
  size(1920, 1200);
  kultainenXoik = width*kultainenleikkaus;
  kultainenYylempi = height*kultainenleikkaus;
  kultainenYalempi = height-kultainenYylempi;
  kultainenXvas = width-kultainenXoik;
  noLoop();
}

void mousePressed() {
  loop();
}

void mouseReleased() {
  noLoop();
}

void piirraTausta(){
  int pun = round(random(0, 20));
  int vihr = round(random(0, 20));
  int sini  = round(random(10, 60));
  background(pun, vihr, sini); //tausta
}

void piirraTahtia(){
  int tahtiLKM = 3;
  if(millis() > aika3){
    tahtiLKM = round(random(50, 500));
  }
  else if(millis()> aika2){
    tahtiLKM = round(random(50, 80));
  }
  else if(millis()> aika1){
    tahtiLKM = round(random(15, 50));
  }


  pensseliTahti();
  for(int i = 0; i < tahtiLKM; i++){
    float x = random(0.05*width, 0.95*width);
    float y = random(0.05*height, 0.82*height);
    float koko = random(1, 6);

    line(x-koko, y+koko, x+koko, y-koko);
    line(x-koko*sqrt(2), y-0,    x+koko*sqrt(2), y+0);
    line(x-koko, y-koko, x+koko, y+koko);

  }
}

void pensseliTahti(){
  strokeWeight(1);
  stroke(255, 128);
}

void draw() {
  piirraTausta();
  piirraKuu();
  piirraTahtia();

  //pushMatrix();
  translate(kultainenXvas,height);
  pensseliPaksuRanka();
  line(0,0,0,-kultainenYalempi*kultainenleikkaus);
  translate(0,-kultainenYalempi*kultainenleikkaus);
  oksita(kultainenYalempi*kultainenleikkaus);
  //popMatrix();

  //piirraLunta();
  //tallennaKuva();
}

void tallennaKuva(){
  float identikaatio = millis();
  String nimi = "kaappaus_"+identikaatio+".jpg";
  save(nimi);
}

void oksita(float h){

  randPituus = random(0.48, 0.72);
  randKulma = random(0.8, 1.2);
  randKulmaKeskimmaiselle = random(-0.1,0.1);
  float randPituusKeskimmaiselle = random(0.6, 0.85);
  float hKesk = h*randPituusKeskimmaiselle;
  h *= randPituus;

  if(h > 8){
    pushMatrix();
    rotate(randKulma);
    piirraRanka(-h);
    translate(0, -h);
    oksita(h);
    popMatrix();

    pushMatrix();
    rotate(randKulmaKeskimmaiselle);
    piirraRanka(-hKesk);
    translate(0, -hKesk);
    oksita(hKesk);
    popMatrix();

    pushMatrix();
    rotate(-randKulma);
    piirraRanka(-h);
    translate(0, -h);
    oksita(h);
    popMatrix();

  }
  else{
    if(millis() > aika3){
      if(randKulmaKeskimmaiselle > 0.0999){
        piirraLehti();
      }
    }
    else if(millis() > aika2){
      if(randKulmaKeskimmaiselle > 0.09){
        piirraLehti();
      }
    }
    else if(millis() > aika1){
      if(randKulmaKeskimmaiselle > 0){
        piirraLehti();
      }
    }
    else{
      piirraLehti();
    }
  }
}

void piirraKuu(){
  fill(255);
  noStroke();
  ellipse(kultainenXoik, kultainenYalempi, 50, 50);
  fill(255, 100);
  ellipse(kultainenXoik, kultainenYalempi, 59, 56);
}

void pensseliOhutRanka(){//412000 = tumma, ruskea
  int pun = round(random(20, 60));
  int vihr = round(random(10, 30));
  int sini  = round(random(0, 20));
  stroke(pun,vihr,sini);
  strokeWeight(2);
}

void pensseliPaksuRanka(){
  int pun = round(random(20, 60));
  int vihr = round(random(10, 30));
  int sini  = round(random(0, 20));
  stroke(pun,vihr,sini);
  strokeWeight(0.01*height);
}

void piirraRanka(float h){
  if(h < -0.1*height){
    pensseliPaksuRanka();
  }
  else{
    pensseliOhutRanka();
  }
  line(0, 0, 0, h);
}

void piirraLehti(){
  pensseliLehti();
  ellipse(0,0, 8, 20);
}

void pensseliLehti(){//keltainen 239, 193, 0
  int pun = round(random(220, 255));
  int vihr = round(random(170, 220));
  int sini  = round(random(0, 20));
  fill(pun,vihr,sini,90);
  strokeWeight(1);
  stroke(255, 50);
}

void pensseliVihreaLehti(){
  int pun = round(random(50, 190));
  int vihr = round(random(120, 255));
  int sini  = round(random(0, 20));
  fill(pun,vihr,sini,70);
  strokeWeight(1);
  stroke(255, 50);
}