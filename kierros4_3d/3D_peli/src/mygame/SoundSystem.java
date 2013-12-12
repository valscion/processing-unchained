package mygame;

import com.jme3.asset.AssetManager;
import com.jme3.audio.AudioNode;

/*
 * Äänten toistamista varten irrotettu systeemi
 */
public class SoundSystem {

    private AudioNode music;
    private AudioNode collisionSound;
    private AudioNode youWinSound;
    private AudioNode rotationSound;
    private AssetManager assetManager;

    public SoundSystem(AssetManager assetManager) {
        this.assetManager = assetManager;
    }

    public void initSounds() {
        music = new AudioNode(assetManager, "Sound/ambient1_freesoundYewbic.wav", false);
        music.setPositional(false);
        music.setDirectional(false);
        music.setLooping(true);
        music.setVolume(0.1f);
        music.play();
        collisionSound = new AudioNode(assetManager, "Sound/collision.wav", false);
        collisionSound.setPositional(false);
        collisionSound.setLooping(false);
        //TODO päivitä vielä oikea
        youWinSound = new AudioNode(assetManager, "Sound/you_win.ogg", false);
        youWinSound.setPositional(false);
        youWinSound.setLooping(false);
        //kääntymisen ääni rotationSound
        rotationSound = new AudioNode(assetManager, "Sound/suih.ogg", false);
        rotationSound.setPositional(false);
        rotationSound.setLooping(false);
    }

    public void playCollisionSound() {
        this.collisionSound.play();
    }

    public void playYouWinSound() {
        this.youWinSound.play();
    }

    public void playRotationSound() {
        this.rotationSound.play();
    }
}
