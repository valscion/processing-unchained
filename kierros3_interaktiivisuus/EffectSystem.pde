import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

// Neat effects
class EffectSystem {
  // Player hit effects
  int timeLastPlayerHit = 0;
  int hitEffectDuration = 1000;
  float hitEffectMagnitude = 10.0;
  // New enemy effects
  List<NewEnemyEffect> newEnemyEffects = new LinkedList<NewEnemyEffect>();

  void onPlayerHit(Enemy enemy, Player player) {
    timeLastPlayerHit = millis();
  }

  void onNewEnemy(Enemy enemy) {
    float enemyEffectX = width;
    float enemyEffectY = enemy.getY() + enemy.height / 2;
    NewEnemyEffect newEffect = new NewEnemyEffect(enemyEffectX, enemyEffectY);
    newEnemyEffects.add(newEffect);
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
    Iterator<NewEnemyEffect> iter = newEnemyEffects.iterator();
    while (iter.hasNext()) {
      NewEnemyEffect effect = iter.next();
      if (effect.isVisible()) {
        effect.draw();
      }
      else {
        // Remove effects that have faded away
        iter.remove();
      }
    }
  }

  class NewEnemyEffect {
    float effectMagnitude = 100.0;
    float currentValue = 0.0;
    float effectX, effectY;

    NewEnemyEffect(float startX, float startY) {
      effectX = startX;
      effectY = startY;
      currentValue = 1.0;
    }

    void draw() {
      currentValue = utils.tweenWeighted(currentValue, 0.0, 10);
      ellipseMode(CENTER);
      fill(currentValue * 255, currentValue * 50, currentValue * 50);
      noStroke();
      float size = currentValue * effectMagnitude;
      ellipse(effectX, effectY, size, size);
    }

    boolean isVisible() {
      return (currentValue > 0.001);
    }
  }
}
