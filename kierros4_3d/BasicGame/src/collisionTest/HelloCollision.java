package collisionTest;
 
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
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.math.Matrix3f;
import com.jme3.math.Quaternion;
import com.jme3.math.Vector3f;
import com.jme3.scene.Node;
import com.jme3.scene.Spatial;
 
/**
 * Example 9 - How to make walls and floors solid.
 * This collision code uses Physics and a custom Action Listener.
 * @author normen, with edits by Zathras
 */
public class HelloCollision extends SimpleApplication
        implements ActionListener {
 
  private Spatial sceneModel;
  private Spatial sceneModel2;
  private BulletAppState bulletAppState;
  private RigidBodyControl landscape;
  private RigidBodyControl landscape2;
  private CharacterControl player;
  private Vector3f walkDirection = new Vector3f();
  private boolean left = false, right = false, up = false, down = false, keyE = false;
  private float xRotation = 0f;
  
  //Temporary vectors used on each frame.
  //They here to avoid instanciating new vectors on each frame
  private Vector3f camDir = new Vector3f();
  private Vector3f camLeft = new Vector3f();
 
  public static void main(String[] args) {
    HelloCollision app = new HelloCollision();
    app.start();
  }
 
  public void simpleInitApp() {
    /** Set up Physics */
    bulletAppState = new BulletAppState();
    stateManager.attach(bulletAppState);
    //tässä oli kommentit että debugi pois päältä
    bulletAppState.getPhysicsSpace().enableDebug(assetManager);
 
    // We re-use the flyby camera for rotation, while positioning is handled by physics
    viewPort.setBackgroundColor(new ColorRGBA(0.7f, 0.8f, 1f, 1f));
    flyCam.setMoveSpeed(100);
    setUpKeys();
    setUpLight();
 /*
            Spatial teapot = assetManager.loadModel("Models/Teapot/Teapot.obj");
        Material mat_default = new Material( 
            assetManager, "Common/MatDefs/Misc/ShowNormals.j3md");
        teapot.setMaterial(mat_default);
        rootNode.attachChild(teapot);
   */ 
    //ladataan tuolta valmis obj filu
    //sceneModel2 = assetManager.loadModel("Models/cube.obj");
    
    // We load the scene from the zip file and adjust its size.
    assetManager.registerLocator("town.zip", ZipLocator.class);
    sceneModel = assetManager.loadModel("main.scene");
    sceneModel2 = assetManager.loadModel("palikoita.blend");
    sceneModel.setLocalScale(0.5f);
    sceneModel2.setLocalScale(2f);
    //cubeModel = assetManager.loadModel("models/cube.obj");
    //cubeModel.setLocalScale(1000f);
 
    // We set up collision detection for the scene by creating a
    // compound collision shape and a static RigidBodyControl with mass zero.
    CollisionShape sceneShape =
            CollisionShapeFactory.createMeshShape((Node) sceneModel);
    CollisionShape sceneShape2 =
            CollisionShapeFactory.createMeshShape((Node) sceneModel2);
    landscape = new RigidBodyControl(sceneShape, 0);
    landscape2 = new RigidBodyControl(sceneShape2, 0);
    sceneModel.addControl(landscape);
    sceneModel2.addControl(landscape2);
 
    // We set up collision detection for the player by creating
    // a capsule collision shape and a CharacterControl.
    // The CharacterControl offers extra settings for
    // size, stepheight, jumping, falling, and gravity.
    // We also put the player in its starting position.
    CapsuleCollisionShape capsuleShape = new CapsuleCollisionShape(1.5f, 6f, 1);
    player = new CharacterControl(capsuleShape, 0.05f);
    player.setJumpSpeed(20);
    player.setFallSpeed(30);
    player.setGravity(30);
    player.setPhysicsLocation(new Vector3f(0, 10, 0));
 
    // We attach the scene and the player to the rootnode and the physics space,
    // to make them appear in the game world.
    rootNode.attachChild(sceneModel);
    rootNode.attachChild(sceneModel2);
    bulletAppState.getPhysicsSpace().add(landscape);
    bulletAppState.getPhysicsSpace().add(landscape2);
    bulletAppState.getPhysicsSpace().add(player);
  }
 
  private void setUpLight() {
    // We add light so we see the scene
    AmbientLight al = new AmbientLight();
    al.setColor(ColorRGBA.White.mult(1.3f));
    rootNode.addLight(al);
 
    DirectionalLight dl = new DirectionalLight();
    dl.setColor(ColorRGBA.White);
    dl.setDirection(new Vector3f(2.8f, -2.8f, -2.8f).normalizeLocal());
    rootNode.addLight(dl);
  }
 
  /** We over-write some navigational key mappings here, so we can
   * add physics-controlled walking and jumping: */
  private void setUpKeys() {
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
  }
 
  /** These are our custom actions triggered by key presses.
   * We do not walk yet, we just keep track of the direction the user pressed. */
  public void onAction(String binding, boolean isPressed, float tpf) {
    if (binding.equals("Left")) {
      left = isPressed;
    } else if (binding.equals("Right")) {
      right= isPressed;
    } else if (binding.equals("Up")) {
      up = isPressed;
    } else if (binding.equals("Down")) {
      down = isPressed;
    } else if (binding.equals("Jump")) {
      if (isPressed) { player.jump(); }
    } else if(binding.equals("RotateWorld")) {
        //sceneModel2.rotate(1,0,0);/*(float)Math.toRadians(90)*/
        this.rotateWorld(0.1f);
    }
  }
 
  private void rotateWorld(float radians){
      //sceneModel2.rotate(radians,0,0);/*(float)Math.toRadians(90)*/
      
      //Quaternion fysiikkaRot = landscape.getPhysicsRotation();
      //fysiikkaRot = fysiikkaRot.normalizeLocal();
      xRotation += radians;
      if (xRotation > 2){
          xRotation = 0;
      }
      landscape2.setPhysicsRotation(new Quaternion(0f,-xRotation/8,xRotation/3,0f));
              //.setPhysicsLocation(player.getViewDirection());
              //.setPhysicsRotation(player.getViewDirection()); 
      //landscape2.setPhysicsRotation(fysiikkaRot);
  }
  
  /**
   * This is the main event loop--walking happens here.
   * We check in which direction the player is walking by interpreting
   * the camera direction forward (camDir) and to the side (camLeft).
   * The setWalkDirection() command is what lets a physics-controlled player walk.
   * We also make sure here that the camera moves with player.
   */
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
        cam.setLocation(player.getPhysicsLocation());
    }
}