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
import com.jme3.renderer.queue.RenderQueue;
import com.jme3.scene.shape.Box;

/**
 * Pohjana on käytetty "collisionTest" valmista testiluokkaa, jonka author:normenhansen
 * http://hub.jmonkeyengine.org/wiki/doku.php/jme3:beginner:hello_collision 
 * Käytetyt materiaalit: Taso(t) olemme itse luoneet sketchUpilla, skyboxia on vähän muokattu, lähde author:Hipshot
 * 
 * Peliin on otettu vaikutteita Portalista, AntiChamberista, Alan Wakesta, ilomilosta. 
 * Pelimekaniikkaan kuuluu painovoiman muuttaminen pelaajan toimesta. 
 * @author Django unchained (Aarne Leinonen, Emmi Linkola, Vesa Laakso, Pauli Putkonen)
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
    private AudioNode music;
    private AudioNode wind;
    private float startTime;
    private static final String PLAYER = "pelaaja";
    private static final String GOAL = "maali";
    private static final String GROUND = "maa";
    private Node goalNode;
    private Node groundNode;
    private int currentLevel;
    
    public static void main(String[] args) {
        Main app = new Main();
        AppSettings settings = new AppSettings(true);
        settings.setSettingsDialogImage("Textures/startscreen.png");
        app.setSettings(settings);
        app.start();
    }
    
    @Override
    public void simpleInitApp() {
        this.currentLevel = 0;
        this.initPhysics();
        this.initMaze();
        this.initSkyBox();
        this.initPlayer();
        this.initLights();
        this.initHUD();
        this.initSounds();
        this.initRotationGfx();
        this.initGoal();
        this.initGround();
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
        flashLight.setPosition(playerControl.getPhysicsLocation());
        flashLight.setDirection(playerControl.getViewDirection());
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
        bulletAppState.getPhysicsSpace().enableDebug(assetManager);
        //kuuntelee tormauksia
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

    private void respawn() {
        this.startTime = timer.getTimeInSeconds();
        bulletAppState.getPhysicsSpace().remove(this.playerControl);
        //en tiedä onko tarpeellisia, ainakin järkevän oloista poistaa pelaaja
        rootNode.removeControl(playerControl);
        rootNode.detachChild(playerNode);
        this.initPlayer();
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
        groundNode = new Node(GROUND);
        Box box = new Box(Vector3f.ZERO, 10f,0.001f,10f);
        Spatial groundSpatial = new Geometry("Box", box );
        groundSpatial.scale(100.0f);
        CollisionShape groundShape = CollisionShapeFactory.createBoxShape(groundSpatial);
        RigidBodyControl groundControl = new RigidBodyControl(groundShape, 0);
        groundNode.addControl(groundControl);
        bulletAppState.getPhysicsSpace().add(groundControl);
        groundControl.setPhysicsLocation(new Vector3f(0, -100, 0));//menee tason alle tarpeeksi kauas
        rootNode.attachChild(groundNode);
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
                playerControl.jump();
            }
        } else if (binding.equals("RotateWorld")) {
            if (!isPressed) {
                this.rotatePlayerUpAxis();
            }
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
        playerControl.setWalkDirection(walkDirection);
        playerControl.setViewDirection(camDir);
        cam.setLocation(playerControl.getPhysicsLocation());
        flashLight.setPosition(playerControl.getPhysicsLocation());
        flashLight.setDirection(playerControl.getViewDirection());
        this.updateRotationGfx();
        this.updateHUD();
    }

    /*
     * Pyöräyttää pelaajan ylöspäin suuntautuvaa akselia, vaihtaen sen suuntaa
     */
    private void rotatePlayerUpAxis() {
        // Rotate the player up axis on Z-Y axis
        int currentUp = playerControl.getUpAxis();
        int newUp = currentUp;

        Vector3f dirVector = this.lookDirection();
        if (currentUp == UpAxisDir.Y) {
            newUp = UpAxisDir.X;
            playerControl.setGravity(-playerControl.getGravity());
        } else if (currentUp == UpAxisDir.X) {
            newUp = UpAxisDir.Y;
        } else {
            throw new RuntimeException("Incorrect up axis, can't rotate!");
        }

        Vector3f upVector = UpAxisDir.unitVector(newUp);
        boolean isGravityFlipped = playerControl.getGravity() < 0;
        if (isGravityFlipped) {
            upVector.multLocal(-1f);
            dirVector.multLocal(-1f);
        }

        // Rotate camera based on up axis and look direction
        cam.lookAtDirection(dirVector, upVector);
        cam.update();

        playerControl.setUpAxis(newUp);
        cam.getUp();
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
        Vector3f direction;
        int upAxis = playerControl.getUpAxis();
        Vector3f playerDir = playerControl.getViewDirection().clone();
        //boolean isGravityFlipped = playerControl.getGravity() < 0;
        switch (upAxis) {
            case UpAxisDir.X:
                playerDir.x = 0;
                if (Math.abs(playerDir.z) > Math.abs(playerDir.y)) {
                    // Katsoo enempi z-akselin suuntaisesti
                    playerDir.y = 0;
                } else {
                    // Katsoo enempi y-akselin suuntaisesti
                    playerDir.z = 0;
                }
                break;
            case UpAxisDir.Y:
                playerDir.y = 0;
                if (Math.abs(playerDir.x) > Math.abs(playerDir.z)) {
                    // Katsoo enempi x-akselin suuntaisesti
                    playerDir.z = 0;
                } else {
                    // Katsoo enempi z-akselin suuntaisesti
                    playerDir.x = 0;
                }
                break;
            case UpAxisDir.Z:
                playerDir.z = 0;
                if (Math.abs(playerDir.x) > Math.abs(playerDir.y)) {
                    // Katsoo enempi x-akselin suuntaisesti
                    playerDir.y = 0;
                } else {
                    // Katsoo enempi y-akselin suuntaisesti
                    playerDir.x = 0;
                }
                break;
            default:
                throw new RuntimeException("Weird up direction!");
        }
        direction = playerDir.normalize();
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
            this.respawn();
        }
    }

    private void nextLevel(){
        this.currentLevel++;
        System.out.println("Pelaaja siirtyy seuraavaan kenttaan");
        if(currentLevel == 1){
            this.playerWon();
        }
    }

    private void playerWon(){
        System.out.println("Pelaaja voittaa pelin!");
        //soittaa musiikkia tai jotain
        //this.stop();
    }

    @Override
    public void simpleRender(RenderManager rm) {
        //TODO: add render code
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

    public void updateRotationGfx() {
        Vector3f location = cam.getLocation().clone();
        location.addLocal(0f, -0.5f, 0f);
        Vector3f lookLocation = location.add(this.lookDirection());
        arrow.setLocalTranslation(location);
        arrow.lookAt(lookLocation, UpAxisDir.unitVector(playerControl.getUpAxis()));
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

    public void updateHUD() {
        this.updateRotationGfx();
        float currentTime = timer.getTimeInSeconds() - this.startTime;
        int currentMinutes = (int) currentTime / 60;
        DecimalFormat df = new DecimalFormat("00.0");
        DecimalFormat hf = new DecimalFormat("00");
        timeText.setText(hf.format(currentMinutes) + ":" + df.format(currentTime % 60));

        String debugText = String.format("Player up axis: %s\nLook vector: %s",
                UpAxisDir.string(playerControl.getUpAxis()),
                this.lookDirection().toString());
        ((BitmapText) guiNode.getChild("DEBUG_TEXT")).setText(debugText);
    }

    public void initSounds() {
        music = new AudioNode(assetManager, "Sound/ambient1_freesoundYewbic.wav", false);
        music.setPositional(false);
        music.setDirectional(false);
        music.setLooping(true);
        music.setVolume(0.1f);
        music.play();
        /*wind = new AudioNode(assetManager, "Sound/wind.wav", false);
        wind.setDirectional(false);
        wind.setPositional(false);
        wind.play();*/
    }

    public void updateSounds() {
    }
}
