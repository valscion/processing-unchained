final Utils utils = new Utils();
class Utils {
  private int lastUpdate = 0;
  private int delta = 0;
  void updateFPSTimer() {
    if (lastUpdate > 0) {
      delta = millis() - lastUpdate;
    }
    lastUpdate = millis();
  }
  // Returns the amount of pixels to move this frame in order to make the
  // movement FPS independent. For example, if you want the player to move 100
  // pixels per sec, you'd just do like this:
  //    player.x += Utils.pxPerSec(100);
  float pxPerSec(float px) {
    return px * delta * 0.001;
  }
}