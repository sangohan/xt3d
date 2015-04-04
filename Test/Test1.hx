package;

import kfsgl.node.MeshNode;
import openfl.geom.Vector3D;
import kfsgl.node.Scene;
import kfsgl.primitives.Sphere;
import kfsgl.core.Geometry;
import kfsgl.camera.Camera;
import flash.geom.Matrix3D;
import kfsgl.renderer.shaders.UniformLib;
import kfsgl.material.Material;
import openfl.display.Sprite;
import openfl.display.OpenGLView;

import kfsgl.Director;
import kfsgl.view.View;
import kfsgl.utils.Color;

class Test1 extends Sprite {
	
	private var _director:Director;


	public function new () {
		super ();

		// Initialise director - one per application delegate
		_director = new Director();
		
		// Create opengl view and as it as a child
		var openglView = new OpenGLView();
		addChild(openglView);

		// Set opengl view in director
		_director.openglView = openglView;

		// Create a new view and add it to the director
		var view = new View();
		view.backgroundColor = new Color(0.8, 0.8, 0.8);

		// Create a camera and set it in the view
		var camera = Camera.create(view);
		view.camera = camera;

		// Create scene and add it to the view
		var scene = Scene.create();
		view.scene = scene;

//		// Add camera to scene
//		scene.addChild(camera);

		// Add view to director
		_director.addView(view);

		// Create a material
		var material:Material = Material.create("test_color");
		material.setProgramName("test_nocolor");

		// create a geometry
		var sphere = Sphere.create(2.0, 16, 16);
		var sphereNode = MeshNode.create(sphere, material);
		sphereNode.position = new Vector3D(0.0, 0.0, 0.0);

		scene.addChild(sphereNode);

		// custom traversal
//		scene.traverse(function (node) {
//			node.visible = true;
//		});

	}
	
}