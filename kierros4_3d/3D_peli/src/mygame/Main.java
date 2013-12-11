package mygame;

import com.jme3.app.SimpleApplication;
import com.jme3.bullet.BulletAppState;
import com.jme3.bullet.collision.shapes.CapsuleCollisionShape;
import com.jme3.bullet.collision.shapes.CollisionShape;
import com.jme3.bullet.control.CharacterControl;
import com.jme3.bullet.control.RigidBodyControl;
import com.jme3.bullet.util.CollisionShapeFactory;
import com.jme3.input.KeyInput;
import com.jme3.input.controls.InputListener;
import com.jme3.input.controls.KeyTrigger;
import com.jme3.light.AmbientLight;
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.math.Quaternion;
import com.jme3.math.Vector3f;
import com.jme3.renderer.RenderManager;
import com.jme3.scene.Geometry;
import com.jme3.scene.Node;
import com.jme3.scene.Spatial;
import com.jme3.scene.shape.Box;
import com.jme3.app.SimpleApplication;
import com.jme3.asset.plugins.ZipLocator;
import com.jme3.bullet.BulletAppState;
import com.jme3.bullet.collision.shapes.CapsuleCollisionShape;
import com.jme3.bullet.collision.shapes.CollisionShape;
import com.jme3.bullet.control.CharacterControl;
import com.jme3.bullet.control.RigidBodyControl;
import com.jme3.bullet.util.CollisionShapeFactory;
import com.jme3.input.KeyInput;
import com.jme3.input.controls.ActionListener;
import com.jme3.input.controls.KeyTrigger;
import com.jme3.light.AmbientLight;
import com.jme3.light.DirectionalLight;
import com.jme3.light.SpotLight;
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.math.FastMath;
import com.jme3.math.Matrix3f;
import com.jme3.math.Quaternion;
import com.jme3.math.Vector3f;
import com.jme3.scene.Mesh;
import com.jme3.scene.Node;
import com.jme3.scene.Spatial;
import com.jme3.scene.debug.Arrow;

/**
 * test
 *
 * @author normenhansen ja Django unchained
 */
public class Main extends SimpleApplication implements ActionListener {

    private Spatial sceneModel;
    private RigidBodyControl landscape;
    private BulletAppState bulletAppState;
    //näppäimille
    private boolean left = false, right = false, up = false, down = false, keyE = false;
    private CharacterControl player;
    private float xRotation = 0f;
    //Temporary vectors used on each frame.
    //They here to avoid instanciating new vectors on each frame
    private Vector3f camDir = new Vector3f();
    private Vector3f camLeft = new Vector3f();
    private Vector3f walkDirection = new Vector3f();
      private Spatial arrow;
    
    // Flashlight
    private SpotLight flashLight;

    public static void main(String[] args) {
        Main app = new Main();
        app.start();
    }

    @Override
    public void simpleInitApp() {
        this.initPhysics();
        this.initMaze();
        this.initPlayer();
        this.initLights();
        this.initGravityArrow();
        // We re-use the flyby camera for rotation, while positioning is handled by physics
        viewPort.setBackgroundColor(new ColorRGBA(0.7f, 0.8f, 1f, 1f));
        flyCam.setMoveSpeed(100);
        setupKeys();
    }

    private void initLights() {
        /**
         * A white ambient light source.
         */
        //AmbientLight ambient = new AmbientLight();
        //ambient.setColor(ColorRGBA.White.mult(0.1f));
        //rootNode.addLight(ambient);
/*
        DirectionalLight dl = new DirectionalLight();
        dl.setColor(ColorRGBA.White.mult(0.1f));
        dl.setDirection(new Vector3f(2.8f, -2.8f, -2.8f).normalizeLocal());
        rootNode.addLight(dl);
       */ 
        flashLight = new SpotLight();
        flashLight.setColor(ColorRGBA.White);
        flashLight.setPosition(player.getPhysicsLocation());
        flashLight.setDirection(player.getViewDirection());
        flashLight.setSpotOuterAngle(10f);
        //flashLight.setSpotOuterAngle(20f);
        rootNode.addLight(flashLight);
    }

    private void initPhysics() {
        /**
         * Set up Physics
         */
        bulletAppState = new BulletAppState();
        stateManager.attach(bulletAppState);
        //tässä oli kommentit että debugi pois päältä
        //bulletAppState.getPhysicsSpace().enableDebug(assetManager);
    }

    private void initMaze() {
        sceneModel = assetManager.loadModel("Models/boksi/boksi.j3o");
        sceneModel.setLocalScale(100f); // Mallit on 10mm luokassa kun maailma on 1m luokassa.
        CollisionShape sceneShape = CollisionShapeFactory.createMeshShape((Node) sceneModel);
        landscape = new RigidBodyControl(sceneShape, 0);//massaksi 1000 niin tippuu alas
        sceneModel.addControl(landscape);
        rootNode.attachChild(sceneModel);
        bulletAppState.getPhysicsSpace().add(landscape);
    }

    private void respawn() {
        bulletAppState.getPhysicsSpace().remove(this.player);
        this.initPlayer();
    }

    private void initPlayer() {
        // We set up collision detection for the player by creating
        // a capsule collision shape and a CharacterControl.
        // The CharacterControl offers extra settings for
        // size, stepheight, jumping, falling, and gravity.
        // We also put the player in its starting position.
        CapsuleCollisionShape capsuleShape = new CapsuleCollisionShape(1.5f, 6f, 1);
        player = new CharacterControl(capsuleShape, 0.05f);
        player.setJumpSpeed(20);
        player.setFallSpeed(30);
        player.setGravity(10);
        player.setPhysicsLocation(new Vector3f(50, 100, -50));
        //pelaaja vielä siihen maaailmaankin...
        bulletAppState.getPhysicsSpace().add(player);
    }

    /**
     * We over-write some navigational key mappings here, so we can add
     * physics-controlled walking and jumping:
     */
    private void setupKeys() {
        inputManager.addMapping("Left", new KeyTrigger(KeyInput.KEY_A));
        inputManager.addMapping("Right", new KeyTrigger(KeyInput.KEY_D));
        inputManager.addMapping("Up", new KeyTrigger(KeyInput.KEY_W));
        inputManager.addMapping("Down", new KeyTrigger(KeyInput.KEY_S));
        inputManager.addMapping("Jump", new KeyTrigger(KeyInput.KEY_SPACE));
        inputManager.addListener(this, "Left");
        inputManager.addListener(this, "Right");
        inputManager.addListener(this, "Up");
        inputManager.addListener(this, "Down");
        inputManager.addListener(this, "Jump");
        inputManager.addMapping("RotateWorld", new KeyTrigger(KeyInput.KEY_E));
        inputManager.addListener(this, "RotateWorld");
        inputManager.addMapping("Respawn", new KeyTrigger(KeyInput.KEY_R));
        inputManager.addListener(this, "Respawn");

    }

    /**
     * These are our custom actions triggered by key presses. We do not walk
     * yet, we just keep track of the direction the user pressed.
     */
    public void onAction(String binding, boolean isPressed, float tpf) {
        if (binding.equals("Left")) {
            left = isPressed;
        } else if (binding.equals("Right")) {
            right = isPressed;
        } else if (binding.equals("Up")) {
            up = isPressed;
        } else if (binding.equals("Down")) {
            down = isPressed;
        } else if (binding.equals("Jump")) {
            if (isPressed) {
                player.jump();
            }
        } else if (binding.equals("RotateWorld")) {
            this.rotateWorld(1f);
        } else if (binding.equals("Respawn")) {
            this.respawn();
        }
    }

    @Override
    public void simpleUpdate(float tpf) {
        camDir.set(cam.getDirection()).multLocal(0.6f);
        camLeft.set(cam.getLeft()).multLocal(0.4f);
        walkDirection.set(0, 0, 0);
        if (left) {
            walkDirection.addLocal(camLeft);
        }
        if (right) {
            walkDirection.addLocal(camLeft.negate());
        }
        if (up) {
            walkDirection.addLocal(camDir);
        }
        if (down) {
            walkDirection.addLocal(camDir.negate());
        }
        player.setWalkDirection(walkDirection);
        player.setViewDirection(camDir);
        cam.setLocation(player.getPhysicsLocation());
        flashLight.setPosition(player.getPhysicsLocation());
        flashLight.setDirection(player.getViewDirection());
        this.updateGravityArrow();
    }

    /*Pyöräyttää landscapea
     * 
     */
    private void rotateWorld(float rotationFloat) {

        xRotation += rotationFloat;
        if (xRotation > 10) {
            xRotation = 1;
        }
        //TODO
        //Quaternion tempQ = this.giveQFromDegree(90, 88, 65);
        //landscape.setPhysicsRotation(tempQ);
        landscape.setPhysicsRotation(new Quaternion(3f, -xRotation, 3f, 3f));
    }

    /*Täytyy tehdä tällänen jolla saadaan helposti oikeenlainen Quaternion
     * @param kolme jotain arvoa
     * @return sitä vastaava Quaternion
     */
    private Quaternion giveQFromDegree(float degreeX, float degreeY, float degreeZ) {
        //logiikka TODO
        return new Quaternion(3f, -degreeY, 3f, 3f);
    }

    @Override
    public void simpleRender(RenderManager rm) {
        //TODO: add render code
    }
    
    public void initGravityArrow(){
        Arrow helpArrow = new Arrow(Vector3f.UNIT_Y);
         helpArrow.setLineWidth(10);
        arrow = new Geometry("Box", helpArrow);
          Material mat1 = new Material(assetManager, 
                "Common/MatDefs/Misc/Unshaded.j3md");
        mat1.setColor("Color", ColorRGBA.White);
        arrow.setMaterial(mat1);
        rootNode.attachChild(arrow);
        
    }
     public void updateGravityArrow(){     
        Vector3f vectorDifference = new Vector3f(cam.getLocation().subtract(arrow.getWorldTranslation()));
        arrow.setLocalTranslation(vectorDifference.addLocal(arrow.getLocalTranslation()));
        // Move it to the bottom right of the screen
        arrow.move(cam.getDirection().mult(3));
        arrow.move(cam.getUp().mult(-0.8f));
        arrow.move(cam.getLeft().mult(-1f));
     }
}
