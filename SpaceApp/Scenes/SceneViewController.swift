//
//  SceneViewController.swift
//  SpaceApp
//
//  Created by Elizaveta Medvedeva on 25.03.24.
//

import UIKit
import SceneKit
import ARKit

// MARK: - SceneViewController
final class SceneViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: Private Properties
    private var planes = [Plane]()
    
    // MARK: Override Metods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - Setup View
private extension SceneViewController {
    
    func setupView() {
        setupSceneView()
        setupTapGestures()
    }
}

// MARK: - Setup UI
private extension SceneViewController {
    
    //MARK: Setting Scene View
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        //Вспомогательные точки поверхности и ось координат
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
                                  //ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    //MARK: Setting Tap Gestures
    func setupTapGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(placeSphere))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(placeUFO))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }
    
    //MARK: @objc Metods
    @objc func placeSphere(tapGesture: UITapGestureRecognizer) {
        guard let sceneView = tapGesture.view as? ARSCNView else { return }
        let location = tapGesture.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(location)
        guard let hitResult = hitTestResult.first else { return }
        
        createSphere(hitResult: hitResult)
    }
    
    @objc func placeUFO(tapGesture: UITapGestureRecognizer) {
        guard let sceneView = tapGesture.view as? ARSCNView else { return }
        let location = tapGesture.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(location)
        guard let hitResult = hitTestResult.first else { return }
        
        createVirtualObject(hitResult: hitResult)
    }
    
    //MARK: Setting Objects
    func createSphere(hitResult: SCNHitTestResult) {
        let position = SCNVector3(
            hitResult.worldCoordinates.x - (size() / 2),
            hitResult.worldCoordinates.y + (size() / 2) + 0.1,
            hitResult.worldCoordinates.z + (size() / 2)
        )
        
        let sphere = Sphere(atPosition: position)
        sceneView.scene.rootNode.addChildNode(sphere)
    }
    
    func createVirtualObject(hitResult: SCNHitTestResult) {
        let position = SCNVector3(
            hitResult.worldCoordinates.x ,
            hitResult.worldCoordinates.y + size() + 0.4,
            hitResult.worldCoordinates.z
        )
        
        let virtualObject = VirtualObject.availableObjects[1]
        virtualObject.position = position
        virtualObject.load()
        sceneView.scene.rootNode.addChildNode(virtualObject)
    }
    
    //MARK: Helpers Metods
    func size() -> Float {
        Float(SizeSphere.point.rawValue)
    }
}

// MARK: - ARSCNViewDelegate
extension SceneViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {
            print("Якоря определены не для поверхности")
            return
        }
        // FIXME: - Убрать !
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
        }.first
        
        // FIXME: - Убрать !
        guard plane != nil else { return }
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}

// MARK: - SCNPhysicsContactDelegate
extension SceneViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
    }
}


