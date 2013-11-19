import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.List; 
import java.util.LinkedList; 
import ddf.minim.analysis.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kierros3_interaktiivisuus extends PApplet {



AudioController audioController;
Player p = new Player(100, 100, 20,0);
Enemy e = new Enemy(500,400,20,20,5);
List<Enemy> enemies = new LinkedList<Enemy>();

public void setup() {
  size(1024, 500);
  background(50);


  // Alustetaan piirtomoodit, niin tiedet\u00e4\u00e4n miten asiat piirtyv\u00e4t.
  // N\u00e4it\u00e4 ei tule muuttaa my\u00f6hemmin!
  ellipseMode(CENTER);
  rectMode(CORNER);

  // Alustetaan audiojutut
  audioController = new AudioController();
}

public void draw() {

  background(50);
  //rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  if(checkEnemyPlayerCollision(e,p) == false){
    p.draw(5);
    e.draw();
    audioController.draw();
  }
}

public boolean checkEnemyPlayerCollision(Enemy e, Player p){
  
  float distanceX = abs(p.getX() - e.getX());
  float distanceY = abs(p.getY() - e.getY());
  
  if (distanceX > (e.width/2 + p.getR())) { return false; }
  if (distanceY > (e.height/2 + p.getR())) { return false; }

  if (distanceX <= (e.width/2)) { return true; }
  if (distanceY <= (e.height/2)) { return true; }

  float cornerDistance_sq = (distanceX - e.width/2)*(distanceX - e.width/2) +
    (distanceY - e.height/2)*(distanceY - e.height/2);

  return (cornerDistance_sq <= (p.getR()*p.getR()));
}

public void inspectList(LinkedList l){
  for(int i = 0; i <l.size(); i ++){
    Enemy e = (Enemy) l.get(i);
    if(e.isActive()){

      if(this.checkEnemyPlayerCollision(e, this.p)){
        e.setInactive();
      }
    }  
  }
}



class AudioController {
  Minim minim;
  AudioInput in;
  FFT fftLin;
  float spectrumScale = 4;
  RingBuffer smallerRingBuffer;
  RingBuffer largerRingBuffer;

  AudioController() {
    minim = new Minim(this);
    in = minim.getLineIn();
    smallerRingBuffer = new RingBuffer(15);
    largerRingBuffer = new RingBuffer(15);
    // create an FFT object that has a time-domain buffer the same size as mics' sample buffer
    // note that this needs to be a power of two
    // and that it means the size of the spectrum will be 1024.
    fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  }

  public void draw() {
    // perform a forward FFT on the samples in mics' mix buffer
    fftLin.forward( in.mix );

    // draw the linear averages
    noStroke();
    {
      int avSize = 150;
      float averages[] = new float[avSize];
      // Lowest frequency from which we start analyzing the sound
      float minFreq = 30;
      // The frequency step between calculated averages
      float step = 4;
      // Average amplitude of all the frequencies to be measured
      float allAverage = fftLin.calcAvg(minFreq, minFreq + avSize*step);
      // Count of frequencies which are louder than the average and either smaller
      // or higher than the middle of analyzed frequency
      int smallerCount = 0;
      int largerCount = 0;
      for (int i = 0; i < avSize; i++) {
        float thisAvg = fftLin.calcAvg(minFreq + i * step, minFreq + (i+1) * step);
        averages[i] = thisAvg;
        if (thisAvg > (allAverage * 0.75f)) {
          if (i > avSize / 2) {
            largerCount++;
          }
          else {
            smallerCount++;
          }
        }
      }
      // Find the strongest frequency band from the averages spectrum for
      // debugging purposes
      int strongestIndex = 0;
      {
        float tmpStrongest = 0.0f;
        for (int i = 0; i < avSize; i++) {
          if (averages[i] > tmpStrongest) {
            tmpStrongest = averages[i];
            strongestIndex = i;
          }
        }
      }

      // Draw the rectangles showing the measured averages
      float height23 = 2 * height / 3;
      int w = PApplet.parseInt( width / averages.length );
      for(int i = 0; i < averages.length; i++) {
        if ( i == strongestIndex ) {
          fill(255, 0, 0);
        }
        else {
            fill(255);
        }
        // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
        float rectHeight = averages[i]*spectrumScale;
        rect(i*w, 200, w, -rectHeight);
      }
      fill(255);

      // If mic input is large enough, store the current smaller and larger frequencies count
      // to a ring buffer in order to be able to smooth the movement of controls
      if (in.mix.level() * 100 > 2.0f) {
        smallerRingBuffer.addValue(smallerCount);
        largerRingBuffer.addValue(largerCount);
      }
      text("Volume: " + in.mix.level() * 100, 10, 30);
    }
    float diff = (smallerRingBuffer.avg() - largerRingBuffer.avg());
    text("Diff: " + diff, 10, 10);
    rect(width - 20, height / 2 + (diff * 5), 20, 5);
  }
}
class Enemy{
  float x;
  float y;
  float width;
  float height;
  float speedX;
  float speedY;
  boolean active;

  Enemy(float x, float y, float width, float height, float speedX){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.speedX = speedX;
    this.active = true;
  }
  public void draw(){
    if(this.active){
      setSpeed();
      x = x-speedX;
      if(x<0){
        x = 1000;
        y = round(random(500));
      }
      fill(200);
      rect(x,y,width,height);
    }
  }
  public void setSpeed(){
    if(millis() < 10000){
      speedX = 3;
    }
    else if(millis() < 20000){
      speedX = 6;
    }
    else if(millis() < 30000){
      speedX = 7;
    }
    else if(millis() < 40000){
      speedX = 9;
    }
    else if(millis() < 50000){
      speedX = 11;
    }
  }
  public void setInactive(){
    this.active = false;
  }
  public boolean isActive(){
    return this.active;
  }
  public float getX(){
    return this.x;
  }

  public float getY(){
    return this.y;
  }
}
class Player{
  float r;
  float x;
  float y;
  int speedY;

  Player(float x, float y, float r, float speedY){
    this.x = x;
    this.y = y;
    this.r =r;

  }
  public void draw(float delta){
    if(this.y < height && this.y >0){
    this.y = y+delta;
    }
    fill(200);
    if(this.y > height-(this.r/2)){
      this.y = height-(this.r/2);
    }
    if(this.y < (this.r/2)){
      this.y = (this.r/2);
    }
    ellipse(x,y,r,r);
  }

  public float getX(){
    return this.x;
  }

  public float getY(){
    return this.y;
  }
  public float getR(){
    return this.r;
  }
}
class RingBuffer {
  int buffer[];
  int currentIndex = 0;
  RingBuffer(int size) {
    buffer = new int[size];
  }

  public void addValue(int value) {
    buffer[currentIndex] = value;
    currentIndex++;
    if (currentIndex >= buffer.length) {
      currentIndex = 0;
    }
  }

  public float avg() {
    float sum = 0.0f;
    for (int i = 0; i < buffer.length; i++) {
      sum += buffer[i];
    }
    float avg = sum / buffer.length;
    return avg;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kierros3_interaktiivisuus" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
