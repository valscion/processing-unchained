// Neat effects
class EffectSystem {
  // Player hit effects
  int timeLastPlayerHit = 0;
  int hitEffectDuration = 1000;
  float hitEffectMagnitude = 10.0;
  // New enemy effects
  int timeLastEnemyAdded = 0;
  int enemyEffectDuration = 200;
  float enemyEffectMagnitude = 100.0;
  float enemyEffectCurrentValue = 0;
  float enemyEffectX, enemyEffectY;

  void onPlayerHit(Enemy enemy, Player player) {
    timeLastPlayerHit = millis();
  }

  void onNewEnemy(Enemy enemy) {
    timeLastEnemyAdded = millis();
    enemyEffectX = width;
    enemyEffectY = enemy.getY() + enemy.height / 2;
  }

  void draw() {
    drawPlayerHitEffect();
    drawNewEnemyEffect();
  }

  void drawPlayerHitEffect() {
    int diffSinceHit = millis() - timeLastPlayerHit;
    if (diffSinceHit < hitEffectDuration) {
      float mappedMagnitude = mapMagnitude(diffSinceHit, hitEffectDuration);
      shakeScreen(mappedMagnitude * hitEffectMagnitude);
    }
  }

  float mapMagnitude(float diff, float duration) {
    float mappedMagnitude = map(diff, 0, duration, 1, 0);
    return mappedMagnitude;
  }

  void shakeScreen(float magnitude) {
    float shakeAmountX = random(-magnitude, magnitude);
    float shakeAmountY = random(-magnitude, magnitude);
    float shakeAmountZ = random(-magnitude, magnitude);
    translate(shakeAmountX, shakeAmountY, shakeAmountZ);
  }

  void drawNewEnemyEffect() {
    int diffSinceAdded = millis() - timeLastEnemyAdded;
    if (diffSinceAdded < enemyEffectDuration) {
      enemyEffectCurrentValue = 1.0;
      timeLastEnemyAdded = 0;
    }
    enemyEffectCurrentValue = utils.tweenWeighted(enemyEffectCurrentValue, 0.0, 10);
    flashCircle(enemyEffectCurrentValue, enemyEffectX, enemyEffectY);
  }

  void flashCircle(float mappedValue, float x, float y) {
    ellipseMode(CENTER);
    fill(mappedValue * 255, mappedValue * 50, mappedValue * 50);
    noStroke();
    float size = mappedValue * enemyEffectMagnitude;
    ellipse(x, y, size, size);
  }
}