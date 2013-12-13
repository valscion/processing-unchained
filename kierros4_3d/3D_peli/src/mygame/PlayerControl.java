package mygame;

import com.jme3.bullet.collision.shapes.CapsuleCollisionShape;
import com.jme3.bullet.control.CharacterControl;

/**
 * Pelaaja, joka reagoi fysiikkaan yms.
 *
 * @author vesa
 */
public class PlayerControl extends CharacterControl {

    PlayerControl(CapsuleCollisionShape capsuleShape, float f) {
        super(capsuleShape, f);
    }

    @Override
    public void update(float tpf) {
        super.update(tpf);
    }
}
