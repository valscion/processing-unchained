import java.util.LinkedList;

class BackgroundPicture{
  LinkedList<Star> stars = new LinkedList<Star>();
  Star s;
  
  BackgroundPicture(){
    for(int i = 0; i<1000; i++){
      this.stars.addLast(new Star(true));
    }
  }
  void draw(){

    background(0);
    Iterator<Star> iter = stars.iterator();
    while(iter.hasNext()){
      iter.next().draw();
    }
    this.stars.addLast(new Star(false));
  }
}

public class Star{
  float x;
  float y;
  float speedX;
  float size;
  
  Star(boolean random){
    if(!random){
    this.x = 1030;
    }
    else{
      this.x = random(0,1024);
    }
    this.y = random(500);
    this.speedX = random(0,100);
    this.size = random(0,4);
  }
  
  void draw(){
    x -= utils.pxPerSec(speedX);
    fill(255);
    ellipse(x,y, this.size, this.size);
  }
}
