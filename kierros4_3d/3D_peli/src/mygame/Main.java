package mygame;

import com.jme3.app.SimpleApplication;
import com.jme3.bullet.BulletAppState;
import com.jme3.bullet.collision.shapes.CollisionShape;
import com.jme3.bullet.control.RigidBodyControl;
import com.jme3.bullet.util.CollisionShapeFactory;
import com.jme3.light.AmbientLight;
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.math.Vector3f;
import com.jme3.renderer.RenderManager;
import com.jme3.scene.Geometry;
import com.jme3.scene.Node;
import com.jme3.scene.Spatial;
import com.jme3.scene.shape.Box;

/**
 * test
 * @author normenhansen
 */
public class Main extends SimpleApplication {
    private Spatial sceneModel;
    private RigidBodyControl landscape;
    private BulletAppState bulletAppState;
    

    public static void main(String[] args) {
        Main app = new Main();
        app.start();
    }

    @Override
    public void simpleInitApp() { 
        /** Set up Physics */
        bulletAppState = new BulletAppState();
        stateManager.attach(bulletAppState);
        //tässä oli kommentit että debugi pois päältä
        bulletAppState.getPhysicsSpace().enableDebug(assetManager);
        
        sceneModel = assetManager.loadModel("Scenes/tyhjaMantu.j3o");
        sceneModel.setLocalScale(1f);//vähän turha ilmottaa 
        CollisionShape sceneShape = CollisionShapeFactory.createMeshShape((Node) sceneModel);
        landscape = new RigidBodyControl(sceneShape, 0);//massaksi 1000 niin tippuu alas
        sceneModel.addControl(landscape);
        rootNode.attachChild(sceneModel);
        bulletAppState.getPhysicsSpace().add(landscape);
        

    /** A white ambient light source. */ 
    AmbientLight ambient = new AmbientLight();
    ambient.setColor(ColorRGBA.White);
    rootNode.addLight(ambient); 
        /*
        Box b = new Box(1, 1, 1);
        Geometry geom = new Geometry("Box", b);

        Material mat = new Material(assetManager, "Common/MatDefs/Misc/Unshaded.j3md");
        mat.setColor("Color", ColorRGBA.Blue);
        geom.setMaterial(mat);

        rootNode.attachChild(geom);*/
    }

    @Override
    public void simpleUpdate(float tpf) {
        //TODO: add update code
    }

    @Override
    public void simpleRender(RenderManager rm) {
        //TODO: add render code
    }
}
