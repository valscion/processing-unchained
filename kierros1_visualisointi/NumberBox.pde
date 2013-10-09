class NumberBox extends ReactsToMouse {
  float x;
  float y;
  boolean isSelected = false;
  String number;

  NumberBox(float x, float y, String number){
    this.x = x;
    this.y = y;
    this.number = number;
  }

  @Override
  boolean areCoordinatesInside(float x, float y){
    if(x > this.x && x < this.x +50 && y > this.y && y < this.y + 30){
      return true;
    }
    return false;
  }

  @Override
  void mouseClicked(){
    isSelected = true;

}
}
