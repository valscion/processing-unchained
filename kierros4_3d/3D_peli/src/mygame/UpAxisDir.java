package mygame;

import com.jme3.math.Vector3f;

/**
 * Luokka, joka helpottaa pelaajan ylöspäin suuntautuvien akseleiden numeroiden
 * ymmärtämistä.
 */
public class UpAxisDir {

    public final static int X = 0;
    public final static int Y = 1;
    public final static int Z = 2;

    public static Vector3f unitVector(int dir) {
        switch (dir) {
            case X:
                return Vector3f.UNIT_X;
            case Y:
                return Vector3f.UNIT_Y;
            case Z:
                return Vector3f.UNIT_Z;
            default:
                throw new IllegalArgumentException("Weird axis direction");
        }
    }

    public static String string(int dir) {
        switch (dir) {
            case X:
                return "X";
            case Y:
                return "Y";
            case Z:
                return "Z";
            default:
                throw new IllegalArgumentException("Weird axis direction");
        }
    }
}