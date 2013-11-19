// Neat effects
class EffectSystem {
  int timeLastPlayerHit = 0;
  int effectDuration = 1000;
  float effectMagnitude = 10.0;

  void onPlayerHit(Enemy enemy, Player player) {
    timeLastPlayerHit = millis();
  }

  void draw() {
    int diffSinceHit = millis() - timeLastPlayerHit;
    if (diffSinceHit < effectDuration) {
      float mappedMagnitude = map(diffSinceHit, 0, effectDuration, 1, 0);
      float magnitude = mappedMagnitude * effectMagnitude;
      shakeScreen(magnitude);
    }
  }

  void shakeScreen(float magnitude) {
    float shakeAmountX = random(-magnitude, magnitude);
    float shakeAmountY = random(-magnitude, magnitude);
    float shakeAmountZ = random(-magnitude, magnitude);
    translate(shakeAmountX, shakeAmountY, shakeAmountZ);
  }
}