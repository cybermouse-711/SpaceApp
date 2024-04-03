//
//  Plane.swift
//  SpaceApp
//
//  Created by Elizaveta Medvedeva on 28.03.24.
//

import ARKit
import SceneKit

// MARK: - Plane
final class Plane: SCNNode {
    
    // MARK: Private Propertis
    private var planeGeometry: SCNPlane!
    
    // MARK: Public Propertis
    var anchor: ARPlaneAnchor!
    
    // MARK: Init
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Metods
    private func configure() {
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        self.planeGeometry.materials = [material]
        
        self.geometry = planeGeometry
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        self.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)
        
//        let physicsShape = SCNPhysicsShape(geometry: self.geometry!, options: nil)
//        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
//        self.physicsBody?.categoryBitMask = BitMask.plane
//        self.physicsBody?.collisionBitMask = BitMask.sphere
//        self.physicsBody?.contactTestBitMask = BitMask.sphere
    }
    
    // MARK: Public Metods
    func update(anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
}
