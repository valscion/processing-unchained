package mygame;

import com.jme3.renderer.RenderManager;
import com.jme3.scene.Geometry;
import com.jme3.app.SimpleApplication;
import com.jme3.audio.AudioNode;
import com.jme3.bullet.BulletAppState;
import com.jme3.bullet.collision.shapes.CapsuleCollisionShape;
import com.jme3.bullet.collision.shapes.CollisionShape;
import com.jme3.bullet.control.CharacterControl;
import com.jme3.bullet.control.RigidBodyControl;
import com.jme3.bullet.util.CollisionShapeFactory;
import com.jme3.font.BitmapText;
import com.jme3.input.KeyInput;
import com.jme3.input.controls.ActionListener;
import com.jme3.input.controls.KeyTrigger;
import com.jme3.light.SpotLight;
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.math.FastMath;
import com.jme3.math.Vector3f;
import com.jme3.scene.Node;
import com.jme3.scene.Spatial;
import com.jme3.system.AppSettings;
import com.jme3.texture.Texture;
import com.jme3.util.SkyFactory;
import java.text.DecimalFormat;
import com.jme3.bullet.collision.PhysicsCollisionEvent;
import com.jme3.bullet.collision.PhysicsCollisionListener;
import com.jme3.effect.ParticleEmitter;
import com.jme3.effect.ParticleMesh;
import com.jme3.niftygui.NiftyJmeDisplay;
import de.lessvoid.nifty.Nifty;
import de.lessvoid.nifty.elements.Element;
import de.lessvoid.nifty.elements.render.TextRenderer;
import de.lessvoid.nifty.screen.Screen;
import de.lessvoid.nifty.screen.ScreenController;
import com.jme3.math.Quaternion;
import com.jme3.renderer.queue.RenderQueue;
import com.jme3.scene.shape.Box;
import com.jme3.ui.Picture;

/**
 * Pohjana on käytetty "collisionTest" valmista testiluokkaa, jonka
 * author:normenhansen
 * http://hub.jmonkeyengine.org/wiki/doku.php/jme3:beginner:hello_collision
 * Käytetyt materiaalit: Taso(t) olemme itse luoneet sketchUpilla, skyboxia on
 * vähän muokattu, lähde author:Hipshot
 *
 * Peliin on otettu vaikutteita Portalista, AntiChamberista, Alan Wakesta,
 * ilomilosta. Pelimekaniikkaan kuuluu painovoiman muuttaminen pelaajan
 * toimesta.
 *
 * @author Django unchained (Aarne Leinonen, Emmi Linkola, Vesa Laakso, Pauli
 * Putkonen)
 */
public class Main extends SimpleApplication implements ActionListener, PhysicsCollisionListener {

    private Spatial sceneModel;
    private RigidBodyControl landscape;
    private BulletAppState bulletAppState;
    //näppäimille
    private boolean left = false, right = false, up = false, down = false, keyE = false;
    private CharacterControl playerControl;
    private Node playerNode;
    //Temporary vectors used on each frame.
    //They here to avoid instanciating new vectors on each frame
    private Vector3f camDir = new Vector3f();
    private Vector3f camLeft = new Vector3f();
    private Vector3f walkDirection = new Vector3f();
    private Spatial arrow;
    // Flashlight
    private SpotLight flashLight;
    private BitmapText timeText;
    private Picture keyPicture;
    private SoundSystem soundSystem;
    private float startTime;
    private boolean timerOn;
    private boolean isQEPressed;
    private static final String PLAYER = "pelaaja";
    private static final String GOAL = "maali";
    private static final String GROUND = "maa";
    private Node goalNode;
    private Node groundNode;
    private int currentLevel;
    public Nifty nifty;
    private NiftyJmeDisplay niftyDisplay;
    private CameraRotator cameraRotator;

    public static void main(String[] args) {
        Main app = new Main();
        AppSettings settings = new AppSettings(true);
        settings.setSettingsDialogImage("Textures/startscreen.png");
        app.setSettings(settings);
        app.start();
    }

    // -------------------------------------------------------------------------
    // INITIALIZE GAME
    // -------------------------------------------------------------------------
    @Override
    public void simpleInitApp() {
        this.currentLevel = 0;
        this.isQEPressed = false;
        this.initPhysics();
        this.initMaze();
        this.initSkyBox();
        this.initPlayer();
        this.initLights();
        this.initSounds();
        this.initGoal();
        this.initGround();
        this.initHUD();
        this.initRotationGfx();
        this.initKeys();
        // We re-use the flyby camera for rotation, while positioning is handled by physics
        viewPort.setBackgroundColor(new ColorRGBA(0.7f, 0.8f, 1f, 1f));
        flyCam.setMoveSpeed(100);
        this.niftyDisplay = new NiftyJmeDisplay(
                assetManager, inputManager, audioRenderer, guiViewPort);
        nifty = niftyDisplay.getNifty();
        nifty.fromXml("Interface/screen.xml", "startscreen");
        guiViewPort.addProcessor(niftyDisplay);
        this.cameraRotator = new CameraRotator(this.cam);
        setDisplayFps(false);       // to hide the FPS
        setDisplayStatView(false);  // to hide the statistics 
    }

    private void initPhysics() {
        bulletAppState = new BulletAppState();
        stateManager.attach(bulletAppState);
        //bulletAppState.getPhysicsSpace().enableDebug(assetManager);
        bulletAppState.getPhysicsSpace().addCollisionListener(this);
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

    private void initSkyBox() {
        Texture sky = assetManager.loadTexture("Textures/skybox/up.png");
        Texture floor = assetManager.loadTexture("Textures/skybox/down.png");
        Texture west = assetManager.loadTexture("Textures/skybox/west.png");
        Texture east = assetManager.loadTexture("Textures/skybox/east.png");
        Texture north = assetManager.loadTexture("Textures/skybox/north.png");
        Texture south = assetManager.loadTexture("Textures/skybox/south.png");
        Spatial skybox = SkyFactory.createSky(
                assetManager, west, east, north, south, sky, floor);
        rootNode.attachChild(skybox);
    }

    private void initPlayer() {
        //pelaajan rankamalli
        CapsuleCollisionShape capsuleShape = new CapsuleCollisionShape(1.5f, 6f, 1);
        playerControl = new CharacterControl(capsuleShape, 0.05f);
        //pelaajan alkusijainnin määrittävä vektori
        Vector3f playerStartPosition = new Vector3f(50, 100, -50);
        //pelaajaan vaikuttavat voimat
        //player.setJumpSpeed(20);
        //player.setFallSpeed(30);
        playerControl.setGravity(10);
        //pelaajan aloitussijainti
        playerControl.setPhysicsLocation(playerStartPosition);
        //pelaaja vielä siihen maaailmaankin...
        bulletAppState.getPhysicsSpace().add(playerControl);
        playerNode = new Node(PLAYER);
        playerNode.setLocalTranslation(playerStartPosition);
        /*TODO jos halutaan pelaajalle joku model pelaajalle
         playerSpatial = assetManager.loadModel("Models/karhu/karhu.mesh.j3o");
         playerSpatial.scale(8.0f);
         playerSpatial.setShadowMode(ShadowMode.CastAndReceive);
         playerSpatial.setLocalTranslation(0.0f, -1.7f, 0.0f);
         playerNode.attachChild(playerSpatial);
         */
        //pelaaja ohjaa nodeaan
        playerNode.addControl(playerControl);
        //pelaajan node maailmaan
        rootNode.attachChild(playerNode);
    }

    private void initLights() {
        flashLight = new SpotLight();
        flashLight.setColor(ColorRGBA.White);
        flashLight.setPosition(playerControl.getPhysicsLocation());
        flashLight.setDirection(playerControl.getViewDirection());
        flashLight.setSpotOuterAngle(10f);
        rootNode.addLight(flashLight);
    }

    public void initSounds() {
        soundSystem = new SoundSystem(assetManager);
        soundSystem.initSounds();
    }

    private void initGoal() {
        goalNode = new Node(GOAL);
        Spatial goalSpatial = assetManager.loadModel("Models/companioncube.j3o");
        goalSpatial.scale(1.0f);

        CollisionShape goalShape =
                CollisionShapeFactory.createMeshShape(goalSpatial);
        RigidBodyControl goalControl = new RigidBodyControl(goalShape, 0);
        goalNode.addControl(goalControl);
        bulletAppState.getPhysicsSpace().add(goalControl);
        Vector3f goalPosition = new Vector3f(40, 90, -40);
        goalControl.setPhysicsLocation(goalPosition);
        goalNode.attachChild(goalSpatial);
        rootNode.attachChild(goalNode);
    }

    private void initGround() {
        //maan päänode nimetty
        groundNode = new Node(GROUND);
        //alas
        Box box = new Box(Vector3f.ZERO, 10f, 0.001f, 10f);
        Spatial groundSpatial = new Geometry("Box", box);
        groundSpatial.scale(100.0f);
        CollisionShape groundShape = CollisionShapeFactory.createBoxShape(groundSpatial);
        RigidBodyControl groundControl = new RigidBodyControl(groundShape, 0);
        groundNode.addControl(groundControl);
        bulletAppState.getPhysicsSpace().add(groundControl);
        groundControl.setPhysicsLocation(new Vector3f(0, -100, 0));//menee tason alle tarpeeksi kauas
        //ylös
        Box box2 = new Box(Vector3f.ZERO, 10f, 0.001f, 10f);
        Spatial groundSpatial2 = new Geometry("Box", box2);
        groundSpatial2.scale(100.0f);
        CollisionShape groundShape2 = CollisionShapeFactory.createBoxShape(groundSpatial2);
        RigidBodyControl groundControl2 = new RigidBodyControl(groundShape2, 0);
        groundNode.addControl(groundControl2);
        bulletAppState.getPhysicsSpace().add(groundControl2);
        groundControl2.setPhysicsLocation(new Vector3f(0, 200, 0));//menee tason alle tarpeeksi kauas
        //x+
        Box box3 = new Box(Vector3f.ZERO, 0.001f, 10f, 10f);
        Spatial groundSpatial3 = new Geometry("Box", box3);
        groundSpatial3.scale(100.0f);
        CollisionShape groundShape3 = CollisionShapeFactory.createBoxShape(groundSpatial3);
        RigidBodyControl groundControl3 = new RigidBodyControl(groundShape3, 0);
        groundNode.addControl(groundControl3);
        bulletAppState.getPhysicsSpace().add(groundControl3);
        groundControl3.setPhysicsLocation(new Vector3f(200, 0, 0));//menee tason alle tarpeeksi kauas
        //x-
        Box box4 = new Box(Vector3f.ZERO, 0.001f,10f, 10f);
        Spatial groundSpatial4 = new Geometry("Box", box4);
        groundSpatial4.scale(100.0f);
        CollisionShape groundShape4 = CollisionShapeFactory.createBoxShape(groundSpatial4);
        RigidBodyControl groundControl4 = new RigidBodyControl(groundShape4, 0);
        groundNode.addControl(groundControl4);
        bulletAppState.getPhysicsSpace().add(groundControl4);
        groundControl4.setPhysicsLocation(new Vector3f(-200, 0, 0));//menee tason alle tarpeeksi kauas
        //y+
        Box box5 = new Box(Vector3f.ZERO, 10f, 10f, 0.001f);
        Spatial groundSpatial5 = new Geometry("Box", box5);
        groundSpatial5.scale(100.0f);
        CollisionShape groundShape5 = CollisionShapeFactory.createBoxShape(groundSpatial5);
        RigidBodyControl groundControl5 = new RigidBodyControl(groundShape5, 0);
        groundNode.addControl(groundControl5);
        bulletAppState.getPhysicsSpace().add(groundControl5);
        groundControl5.setPhysicsLocation(new Vector3f(0, 0, -200));//menee tason alle tarpeeksi kauas
        //y-
        Box box6 = new Box(Vector3f.ZERO, 10f, 10f, 0.001f);
        Spatial groundSpatial6 = new Geometry("Box", box6);
        groundSpatial6.scale(100.0f);
        CollisionShape groundShape6 = CollisionShapeFactory.createBoxShape(groundSpatial6);
        RigidBodyControl groundControl6 = new RigidBodyControl(groundShape6, 0);
        groundNode.addControl(groundControl6);
        bulletAppState.getPhysicsSpace().add(groundControl6);
        groundControl6.setPhysicsLocation(new Vector3f(0, 0, 200));//menee tason alle tarpeeksi kauas
        //asettaminen oikein
        groundControl.setPhysicsLocation(new Vector3f(0, -100, 0));//menee tason alle tarpeeksi kauas
        rootNode.attachChild(groundNode);
    }

    public void initHUD() {
        timeText = new BitmapText(guiFont, false);
        timeText.setSize(30);      // font size
        timeText.setColor(ColorRGBA.White);
        timeText.setLocalTranslation(0, settings.getHeight(), 0); // position
        guiNode.attachChild(timeText);
        this.initDebugText();
    }

    private void initDebugText() {
        BitmapText hudText = new BitmapText(guiFont, false);
        hudText.setName("DEBUG_TEXT");
        hudText.setSize(guiFont.getCharSet().getRenderedSize());
        hudText.setColor(ColorRGBA.Black);
        hudText.setLocalTranslation(300, hudText.getLineHeight() * 2, 0);
        guiNode.attachChild(hudText);
    }

    public void initRotationGfx() {
        Box helpBox = new Box(0.1f, 0.1f, -10f);
        arrow = new Geometry("Box", helpBox);
        Material mat1 = new Material(assetManager,
                "Common/MatDefs/Misc/Unshaded.j3md");
        mat1.setColor("Color", ColorRGBA.Blue);
        arrow.setMaterial(mat1);
        arrow.setShadowMode(RenderQueue.ShadowMode.Off);
        arrow.setCullHint(Spatial.CullHint.Never);
        arrow.setLocalTranslation(50, 100, -50);
        rootNode.attachChild(arrow);
    }

    /**
     * We over-write some navigational key mappings here, so we can add
     * physics-controlled walking and jumping:
     */
    private void initKeys() {
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

    //
    // -------------------------------------------------------------------------
    // END GAME INITIALIZE
    // -------------------------------------------------------------------------
    //
    @Override
    public void simpleUpdate(float tpf) {
        cameraRotator.update(tpf);
        if (cameraRotator.isInterpolationComplete()) {
            playerControl.setEnabled(true);
            updatePlayerAndCameraPosition();
        } else {
            playerControl.setEnabled(false);
        }
        flashLight.setPosition(playerControl.getPhysicsLocation());
        flashLight.setDirection(playerControl.getViewDirection());
        this.updateRotationGfx();
        this.updateHUD(isQEPressed);
    }

    @Override
    public void simpleRender(RenderManager rm) {
        //TODO: add render code
    }

    private void updatePlayerAndCameraPosition() {
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
        playerControl.setWalkDirection(walkDirection);
        playerControl.setViewDirection(camDir);
        cam.setLocation(playerControl.getPhysicsLocation());
    }

    private void respawn() {
        playerControl.setEnabled(true);
        this.startTime = timer.getTimeInSeconds();
        bulletAppState.getPhysicsSpace().remove(this.playerControl);
        //en tiedä onko tarpeellisia, ainakin järkevän oloista poistaa pelaaja
        rootNode.removeControl(playerControl);
        rootNode.detachChild(playerNode);
        this.timerOn = true;
        this.initPlayer();
    }

    /**
     * These are our custom actions triggered by key presses. We do not walk
     * yet, we just keep track of the direction the user pressed.
     */
    public void onAction(String binding, boolean isPressed, float tpf) {
        if(!guiViewPort.getProcessors().contains(niftyDisplay)){
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
                playerControl.jump();
            }
        } else if (binding.equals("RotateWorld")) {
            if (!isPressed) {
                this.rotateWorld();
                this.isQEPressed = true;
                this.updateHUD(isQEPressed);
            }
        }
    }
        if (binding.equals("Respawn")) {
            this.respawn();
            if (guiViewPort.getProcessors().contains(niftyDisplay)) {
                guiViewPort.removeProcessor(niftyDisplay);
            }
        }
    }

    /**
     * Pyöräyttää maailmaa
     */
    private void rotateWorld() {
        if (this.cameraRotator.isInterpolationComplete()) {
            this.soundSystem.playRotationSound();
            this.rotatePlayerUpAxis();
            this.rotateCamera();
        }
    }

    /*
     * Pyöräyttää pelaajan ylöspäin suuntautuvaa akselia, vaihtaen sen suuntaa
     */
    private void rotatePlayerUpAxis() {
        // Rotate the player up axis on Z-Y axis
        int currentUp = playerControl.getUpAxis();
        int newUp = currentUp;

        if (currentUp == UpAxisDir.Y) {
            newUp = UpAxisDir.X;
            playerControl.setGravity(-playerControl.getGravity());
        } else if (currentUp == UpAxisDir.X) {
            newUp = UpAxisDir.Y;
        } else {
            throw new RuntimeException("Incorrect up axis, can't rotate!");
        }

        playerControl.setUpAxis(newUp);
    }

    /**
     * Pyöräytä kamera sopimaan käännettyyn maailmaan
     */
    private void rotateCamera() {
        this.cameraRotator.rotateToReflectNewPlayerUpAxis(playerControl);
    }

    /**
     * Hae katsomissuunta siten, että se on nykyisen pinnan mukainen ja tasan
     * jonkun tietyn akselin suuntainen (eli aina 90 asteen pätkissä).
     *
     * Tämän avulla voi tietää, miten pelimaailmaa tulee kääntää.
     *
     * @return
     */
    private Vector3f lookDirection() {
        Vector3f direction = cameraRotator.lookDirection(playerControl);
        return direction;
    }

    public void collision(PhysicsCollisionEvent event) {
        //System.out.println("TÖRMÄYS");
        //vähentää syntyvää laskentaa kolmasosaan, ei suurta vaikutusta toteutukseen
        if (FastMath.nextRandomFloat() < 0.3f) {
            if (event.getNodeA().getName().equals(PLAYER)) {
                handlePlayerCollision(event.getNodeB().getName(), event);
            } else if (event.getNodeB().getName().equals(PLAYER)) {
                handlePlayerCollision(event.getNodeA().getName(), event);
            }
        }
    }

    private void handlePlayerCollision(String objectName, PhysicsCollisionEvent event) {
        if (objectName.equals(GOAL)) {
            //Pelaaja voittaa pelin
            System.out.println("Pelaaja paasee maaliin!");
            this.nextLevel();
        } else if (objectName.equals(GROUND)) {
            this.soundSystem.playCollisionSound();
            this.respawn();
            nifty.fromXml("Interface/screen.xml", "lose");
            guiViewPort.addProcessor(niftyDisplay);
            timerOn=false;
        }
    }

    private void nextLevel() {
        this.currentLevel++;
        System.out.println("Pelaaja siirtyy seuraavaan kenttaan");
        this.soundSystem.playYouWinSound();
        //this.playYouWinSound();
        if (currentLevel >= 1) {
            this.playerWon();
        }
    }

    private void playerWon() {
        System.out.println("Pelaaja voittaa pelin!");
        nifty.fromXml("Interface/screen.xml", "win");
        guiViewPort.addProcessor(niftyDisplay);
        this.respawn();
        playerControl.setEnabled(false);
        timerOn = false;
        //soittaa musiikkia tai jotain
        //this.stop();
    }

    public void updateRotationGfx() {
        Vector3f location = cam.getLocation().clone();
        location.addLocal(0f, -0.5f, 0f);
        Vector3f lookLocation = location.add(this.lookDirection());
        arrow.setLocalTranslation(location);
        arrow.lookAt(lookLocation, UpAxisDir.unitVector(playerControl.getUpAxis()));
    }

    public void updateHUD(boolean showqe) {
        if (!guiViewPort.getProcessors().contains(niftyDisplay)) {
            
                this.updateRotationGfx();
                if (timerOn) {
                float currentTime = timer.getTimeInSeconds() - this.startTime;
                int currentMinutes = (int) currentTime / 60;
                DecimalFormat df = new DecimalFormat("00.0");
                DecimalFormat hf = new DecimalFormat("00");
                timeText.setText(hf.format(currentMinutes) + ":" + df.format(currentTime % 60));
            }
            String debugText = String.format("Player up axis: %s\nLook vector: %s",
                    UpAxisDir.string(playerControl.getUpAxis()),
                    this.lookDirection().toString());
            ((BitmapText) guiNode.getChild("DEBUG_TEXT")).setText(debugText);
            if (showqe) {
                keyPicture.removeFromParent();
                keyPicture = new Picture("QA-picture");
                keyPicture.setImage(assetManager, "Textures/keys.png", true);
                keyPicture.setHeight(80f);
                keyPicture.setWidth(152f);
                keyPicture.setPosition(settings.getWidth() / 2 - 76f, settings.getHeight() - 80f);
                guiNode.attachChild(keyPicture);
            } else {
                if (keyPicture != null) {
                    keyPicture.removeFromParent();
                }
                keyPicture = new Picture("QA-picture");
                keyPicture.setImage(assetManager, "Textures/allkeys.png", true);
                keyPicture.setHeight(150f);
                keyPicture.setWidth(150f);
                keyPicture.setPosition(settings.getWidth() / 2 - 75f, settings.getHeight() - 150f);
                guiNode.attachChild(keyPicture);
            }
        }
    }

    public void updateSounds() {
        //TODO, jos pelaaja tipahtaa
    }
}
