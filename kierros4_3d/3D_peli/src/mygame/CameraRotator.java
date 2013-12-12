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

    public boolean isInterpolationComplete() {
        if (!isTargetChanged) {
            return true;
        }
        float diffs = quatDiff(cam.getRotation(), targetRotation);
        if (diffs < 0.0001f) {
            System.out.println("Interpolation complete!");
            return true;
        } else {
            return false;
        }
    }

    private float quatDiff(Quaternion a, Quaternion b) {
        float diffs = Math.abs(a.getX() - b.getX())
                + Math.abs(a.getY() - b.getY())
                + Math.abs(a.getZ() - b.getZ())
                + Math.abs(a.getW() - b.getW());
        return diffs;
    }

    private void interpolateRotation(float tpf) {
        Quaternion currentRot = cam.getRotation();
        Quaternion newRot = currentRot.clone();
        newRot.slerp(targetRotation, tpf * 5);
        cam.setRotation(newRot);
    }

    private Quaternion tween(Quaternion current, Quaternion target) {
        float newX, newY, newZ, newW;

        newX = tweenWeighted(current.getX(), target.getX(), 10);
        newY = tweenWeighted(current.getY(), target.getY(), 10);
        newZ = tweenWeighted(current.getZ(), target.getZ(), 10);
        newW = tweenWeighted(current.getW(), target.getW(), 10);

        return new Quaternion(newX, newY, newZ, newW);
    }

    // Helper for animating change
    public float tweenWeighted(float currentValue, float targetValue, int slowdownFactor) {
        return ((currentValue * (slowdownFactor - 1)) + targetValue) / slowdownFactor;
    }
}
