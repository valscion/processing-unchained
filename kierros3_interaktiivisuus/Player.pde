class Player{
  int r;
  int x;
  int y;
  int speedY;
  Player(int x, int y, int r, int speedY){
    this.x = x;
    this.y = y;
    this.r =r;

  }
  void draw(int delta){
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

  int getX(){
    return this.x;
  }

  int getY(){
    return this.y;
  }
  int getR(){
    return this.r;
  }
}
