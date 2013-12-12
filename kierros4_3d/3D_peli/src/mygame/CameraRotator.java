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

    public void rotateToReflectNewPlayerUpAxis(CharacterControl playerControl) {
        Vector3f dirVector = this.lookDirection(playerControl);
        float rotateAngle = getAngleToRotateTo(playerControl);
        // Rotate camera based on up axis and look direction
        //cam.lookAtDirection(dirVector, cam.getUp());
        Quaternion target = new Quaternion();
        target.fromAngleAxis(rotateAngle, dirVector);
        this.rotateTo(target);
    }

    private float getAngleToRotateTo(CharacterControl playerControl) {
        float rotateAngle = 0.0f;
        int playerUpAxis = playerControl.getUpAxis();
        boolean isGravityFlipped = playerControl.getGravity() < 0;
        if (playerUpAxis == UpAxisDir.X) {
            rotateAngle = -FastMath.HALF_PI;
            if (isGravityFlipped) {
                rotateAngle = -rotateAngle;
            }
        } else if (playerUpAxis == UpAxisDir.Y) {
            if (isGravityFlipped) {
                rotateAngle = FastMath.PI;
            }
        }
        return rotateAngle;
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
