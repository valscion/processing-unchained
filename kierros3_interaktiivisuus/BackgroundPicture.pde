import java.util.LinkedList;

class BackgroundPicture{
  LinkedList<Note> notes = new LinkedList<Note>();
  PImage bg;
  int lastDraw;
  BackgroundPicture(){
    bg = loadImage("Music-staff.png");
    lastDraw = millis();
  }
  void draw(){
    background(bg);
    if(millis()-lastDraw  >= 1000){
      
      lastDraw = millis(); 
      Note n = new Note(0, audioController.soundValue());
      System.out.println(audioController.soundValue());
      notes.addLast(n);
    }
    Iterator<Note> iter = notes.iterator();
    while(iter.hasNext()){
      Note note = iter.next();

      note.x += utils.pxPerSec(150);
      
      note.draw();
    }
    
  }
}

public class Note{
  float x;
  float y;
  PImage pic;
  Note(float x, float y){
    if( y>-1.0){
      this.y = -150/2;
    }
    if(y>0.8){
      this.y = -80/2;
    }
    if(y>-0.6){
      this. y = -30/2;
    }
    if(y>-0.4){
      this.y = 30/2;
    }
    if(y>-0.2){
      this.y = 90/2;
    }
    if(y>0){
      this.y = 150/2;
    }
    if(y>0.2){
      this.y = 210/2;
    }
    if(y>0.4){
      this.y = 270/2;
    }
    if(y>0.6){
      this.y = 340/2;
        }
    if(y>0.8){
     this. y = 390/2;
    }
    this.x = x;
    pic = loadImage("music-note.png");
  }
  void draw(){
      image(this.pic,this.x, this.y);
  }

}
