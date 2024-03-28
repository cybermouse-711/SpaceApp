//
//  Sphere.swift
//  SpaceApp
//
//  Created by Elizaveta Medvedeva on 28.03.24.
//

import ARKit
import SceneKit

// MARK: - Sphere
final class Sphere: SCNNode {
    
    // MARK: Init
    init(atPosition position: SCNVector3) {
        super.init()
        self.position = position
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Metods
    private func configure() {
        let sphereGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        sphereGeometry.materials = [material]
        
        self.geometry = sphereGeometry
    }
}
