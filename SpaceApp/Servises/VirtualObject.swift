//
//  VirtualObject.swift
//  SpaceApp
//
//  Created by Elizaveta Medvedeva on 02.04.24.
//

import SceneKit

// MARK: - VirtualObject
final class VirtualObject: SCNReferenceNode {
    
    static let availableObjects: [SCNReferenceNode] = {
        guard let modelsURLs = Bundle.main.url(forResource: "art.scnassets", withExtension: nil) else { return [] }
        
        let fileEnum = FileManager().enumerator(at: modelsURLs, includingPropertiesForKeys: nil)!
        
        return fileEnum.compactMap { element in
            guard let url = element as? URL else { return nil }
            guard url.pathExtension == "scn" else { return nil }
            return VirtualObject(url: url)
        }
    }()
}
