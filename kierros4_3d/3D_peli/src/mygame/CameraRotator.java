/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mygame;

import com.jme3.bullet.control.CharacterControl;
import com.jme3.math.Quaternion;
import com.jme3.math.Vector3f;
import com.jme3.renderer.Camera;

/**
 *
 * @author vesa
 */
public class CameraRotator {

    private Camera cam;
    private CharacterControl player;
    private Quaternion targetRotation = new Quaternion();
    private boolean isTargetChanged = false;

    public CameraRotator(Camera cam, CharacterControl player) {
        this.cam = cam;
        this.player = player;
    }

    public void update(float tpf) {
        if (isTargetChanged) {
            if (isInterpolationComplete()) {
                cam.setRotation(targetRotation);
                isTargetChanged = false;
            } else {
                interpolateRotation(tpf);
            }
        }
    }

    public void rotateTo(Quaternion targetRotation) {
        if (!isTargetChanged) {
            this.targetRotation.set(targetRotation);
            isTargetChanged = true;
        }
    }

    private boolean isInterpolationComplete() {
        return false;
    }

    private void interpolateRotation(float tpf) {
        Quaternion currentRot = cam.getRotation();
        Quaternion newRot = currentRot.clone();
        newRot.slerp(targetRotation, tpf);
        cam.setRotation(newRot);
    }

    // Helper for animating change
    float tweenWeighted(float currentValue, float targetValue, int slowdownFactor) {
        return ((currentValue * (slowdownFactor - 1)) + targetValue) / slowdownFactor;
    }
}
