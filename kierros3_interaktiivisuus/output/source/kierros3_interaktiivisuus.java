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
LinkedList<Enemy> enemies = new LinkedList<Enemy>();

public void setup() {
  size(1024, 500);
  background(50);


  // Alustetaan piirtomoodit, niin tiedet\u00e4\u00e4n miten asiat piirtyv\u00e4t.
  // N\u00e4it\u00e4 ei tule muuttaa my\u00f6hemmin!
  ellipseMode(CENTER);
  rectMode(CORNER);

  // Alustetaan audiojutut
  audioController = new AudioController();
  enemies.addLast(e);
}

public void draw() {

  background(50);
  //rect((width - 30) / 2, (height - 30 ) / 2, 30, 30);
  p.draw(audioController.speed()*10);
  this.goThroughEnemyList(enemies);
  audioController.update();
  audioController.drawDebug();
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

public void goThroughEnemyList(LinkedList l){
  for(int i = 0; i <l.size(); i ++){
    Enemy e = (Enemy) l.get(i);
    if(e.isActive()){
      if(this.checkEnemyPlayerCollision(e, this.p)){
        e.setInactive();
      }
    }
    e.draw();
  }
}



class AudioController {
  Minim minim;
  AudioInput in;
  FFT fftLin;
  RingBuffer smallerRingBuffer;
  RingBuffer largerRingBuffer;

  // The lower bound limit of microphones loudness
  float minimumVolume = 2.0f;

  // ----------------
  // Constants controlling highest frequency pick
  // ----------------
  // How many averages will be counted
  private final int AVERAGES_COUNT = 150;
  // The array to store all the averages. This needs to be initialized only once
  // and the values can be replaced
  private final float AVERAGES_ARR[] = new float[AVERAGES_COUNT];
  // Lowest frequency from which we start analyzing the sound
  private final float MIN_FREQ = 30;
  // The frequency step between calculated averages
  private final float FREQ_STEP = 4;

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

  // Updates the frequency values. This should be called in every frame.
  public void update() {
    // perform a forward FFT on the samples in mics' mix buffer
    fftLin.forward( in.mix );

    // Average amplitude of all the frequencies to be measured
    float allAverage = fftLin.calcAvg(MIN_FREQ, MIN_FREQ + AVERAGES_COUNT*FREQ_STEP);

    // Count of frequencies which are louder than the average and either smaller
    // or higher than the middle of analyzed frequency
    int smallerCount = 0;
    int largerCount = 0;
    for (int i = 0; i < AVERAGES_COUNT; i++) {
      float thisAvg = fftLin.calcAvg(MIN_FREQ + i * FREQ_STEP, MIN_FREQ + (i+1) * FREQ_STEP);
      AVERAGES_ARR[i] = thisAvg;
      // Store the value of this frequency band to largerCount or smallerCount
      // if it's amplitude is stronger than 3/4 of the average amplitude
      if (thisAvg > (allAverage * 0.75f)) {
        if (i > AVERAGES_COUNT / 2) {
          largerCount++;
        }
        else {
          smallerCount++;
        }
      }
    }

    if (isSoundLoudEnough()) {
      // Store the current smaller and larger frequencies count to a ring buffer
      // in order to be able to smooth the movement of controls
      smallerRingBuffer.addValue(smallerCount);
      largerRingBuffer.addValue(largerCount);
    }
  }

  // Checks whether the current volume should be counted as loud enough
  public boolean isSoundLoudEnough() {
    float currentVolume = getCurrentSoundVolume();
    return (currentVolume > minimumVolume);
  }

  // Gets the current sound volume
  public float getCurrentSoundVolume() {
    return in.mix.level() * 100;
  }

  // Sets the new sound limit. If the sound coming from the microphone is more
  // quiet than the value in here, it will not be registered.
  public void setSoundLimit(float newLimit) {
    if (newLimit <= 0.0f) {
      throw new IllegalArgumentException("Incorrect sound limit");
    }
    minimumVolume = newLimit;
  }

  // Draws some debug info to the screen
  public void drawDebug() {
    noStroke();
    float spectrumScale = 4;
    // Find the strongest frequency band from the averages spectrum for
    // debugging purposes
    int strongestIndex = 0;
    {
      float tmpStrongest = 0.0f;
      for (int i = 0; i < AVERAGES_COUNT; i++) {
        if (AVERAGES_ARR[i] > tmpStrongest) {
          tmpStrongest = AVERAGES_ARR[i];
          strongestIndex = i;
        }
      }
    }

    // Draw the rectangles showing the measured averages
    float height23 = 2 * height / 3;
    int w = PApplet.parseInt( width / AVERAGES_ARR.length );
    for(int i = 0; i < AVERAGES_ARR.length; i++) {
      if ( i == strongestIndex ) {
        fill(255, 0, 0);
      }
      else {
        fill(255);
      }
      // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
      float rectHeight = AVERAGES_ARR[i]*spectrumScale;
      rect(i*w, 200, w, -rectHeight);
    }
    fill(255);
    text("Volume: " + in.mix.level() * 100, 10, 30);

    float speed = speed();
    text("Speed: " + speed, 10, 10);
    float yChange = speed * ((height - 5) / 2);
    rect(width - 20, height / 2 + yChange, 20, 5);
  }

  // Returns the value of sound frequency which can be used to control various
  // things. The speed value will be in range [-1, 1]
  public float speed() {
    float diff = (smallerRingBuffer.avg() - largerRingBuffer.avg());
    float clamped = constrain(diff, -40, 40);
    float mappedValue = map(clamped, -40, 40, -1, 1);
    return mappedValue;
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
    return this.r/2;
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
