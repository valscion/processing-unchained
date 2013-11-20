class Player{
  float r;
  float x;
  float y;
  float speedY = 0;
  final float SPEED_FACTOR = 300.0;
  int timeWhenSpeedSet = 0;
  int lives;
  PImage ppic;

  Player(float x, float y, float r, float speedY){
    this.x = x;
    this.y = y;
    this.r = r;
    this.ppic = loadImage("spaceship.png");
  }
  void enemyHit(){
    this.lives = this.lives-1;
  }

  void draw(){
    if(this.y < height && this.y >0){
      this.y = y + this.speedY * SPEED_FACTOR;
    }
    fill(200);
    if(this.y > height-(this.r/2)){
      this.y = height-(this.r/2);
    }
    if(this.y < (this.r/2)){
      this.y = (this.r/2);
    }
    imageMode(CENTER);
    //ellipse(x,y,r,r);
    image(ppic, x,y,r,r);
    imageMode(CORNER);
    // Muuta vauhtia hitaasti nollaa kohti, kun viime nopeuden asetuksesta on
    // kulunut yli 100ms
    if (millis() - this.timeWhenSpeedSet > 100) {
      int diff = millis() - this.timeWhenSpeedSet;
      this.speedY = utils.tweenWeighted(this.speedY, 0, 20);
    }
  }

  float getX(){
    return this.x;
  }

  float getY(){
    return this.y;
  }
  float getR(){
    return this.r/2;
  }

  // Sets the new speed, which is clamped between -1...1
  void setSpeed(float newSpeed) {
    this.timeWhenSpeedSet = millis();
    this.speedY = constrain(newSpeed, -1, 1);
  }
}
