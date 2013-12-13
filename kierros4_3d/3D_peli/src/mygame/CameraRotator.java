/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mygame;

import com.jme3.bullet.control.CharacterControl;
import com.jme3.math.FastMath;
import com.jme3.math.Quaternion;
import com.jme3.math.Vector3f;
import com.jme3.renderer.Camera;

/**
 *
 * @author vesa
 */
public class CameraRotator {

    private Camera cam;
    private Quaternion targetRotation = new Quaternion();
    private boolean isTargetChanged = false;

    public CameraRotator(Camera cam) {
        this.cam = cam;
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

    public void rotateToReflectNewPlayerUpAxis(CharacterControl playerControl, Vector3f lookDir, boolean clockWise) {
        Vector3f playerUpVec = UpAxisDir.unitVector(playerControl.getUpAxis());
        boolean isGravityFlipped = playerControl.getGravity() < 0;
        if (isGravityFlipped) {
            playerUpVec.multLocal(-1);
        }
        Quaternion target = new Quaternion();
        target.lookAt(lookDir, playerUpVec);
        this.rotateTo(target);
    }

    public void reset() {
        Vector3f startUp = Vector3f.UNIT_Y;
        Quaternion target = new Quaternion();
        target.lookAt(Vector3f.UNIT_Z.mult(-1f), startUp);
        this.targetRotation.set(target);
        this.isTargetChanged = false;
        this.cam.setRotation(target);
    }

    /**
     * Hae katsomissuunta siten, että se on nykyisen pinnan mukainen ja tasan
     * jonkun tietyn akselin suuntainen (eli aina 90 asteen pätkissä).
     *
     * Tämän avulla voi tietää, miten pelimaailmaa tulee kääntää.
     *
     * @return
     */
    public Vector3f lookDirection(CharacterControl playerControl) {
        int upAxis = playerControl.getUpAxis();
        Vector3f playerDir = playerControl.getViewDirection().clone();
        //boolean isGravityFlipped = playerControl.getGravity() < 0;
        switch (upAxis) {
            case UpAxisDir.X:
                playerDir.x = 0;
                if (Math.abs(playerDir.z) > Math.abs(playerDir.y)) {
                    // Katsoo enempi z-akselin suuntaisesti
                    playerDir.y = 0;
                    playerDir.z = (playerDir.z < 0) ? -1 : 1;
                } else {
                    // Katsoo enempi y-akselin suuntaisesti
                    playerDir.z = 0;
                    playerDir.y = (playerDir.y < 0) ? -1 : 1;
                }
                break;
            case UpAxisDir.Y:
                playerDir.y = 0;
                if (Math.abs(playerDir.x) > Math.abs(playerDir.z)) {
                    // Katsoo enempi x-akselin suuntaisesti
                    playerDir.z = 0;
                    playerDir.x = (playerDir.x < 0) ? -1 : 1;
                } else {
                    // Katsoo enempi z-akselin suuntaisesti
                    playerDir.x = 0;
                    playerDir.z = (playerDir.z < 0) ? -1 : 1;
                }
                break;
            case UpAxisDir.Z:
                playerDir.z = 0;
                if (Math.abs(playerDir.x) > Math.abs(playerDir.y)) {
                    // Katsoo enempi x-akselin suuntaisesti
                    playerDir.y = 0;
                    playerDir.x = (playerDir.x < 0) ? -1 : 1;
                } else {
                    // Katsoo enempi y-akselin suuntaisesti
                    playerDir.x = 0;
                    playerDir.y = (playerDir.y < 0) ? -1 : 1;
                }
                break;
            default:
                throw new RuntimeException("Weird up direction!");
        }
        return playerDir;
    }

    public boolean isInterpolationComplete() {
        if (!isTargetChanged) {
            return true;
        }
        float diffs = quatDiff(cam.getRotation(), targetRotation);
        if (diffs < 0.01f) {
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
        float diff = quatDiff(currentRot, targetRotation);
        float interpAmount = tpf * 5;
        if (diff > 0.01f && diff < 1.0f) {
            interpAmount *= ((1 - diff) * FastMath.PI);
        }
        newRot.slerp(targetRotation, interpAmount);
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
