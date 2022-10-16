//
//  NatureView.swift
//  Pompy3
//
//  Created by Brayton Lordianto on 10/15/22.
//

import SwiftUI
import Foundation
import RealityKit
import ARKit
import Combine

struct NatureView: View {
    var body: some View {
        NatureARView()
            .ignoresSafeArea()
    }
}

struct NatureARView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        print("Called here")
        let arView = ARView(frame: .zero)
//        print("DEBUG:: ")x
//        print("DEBUG: worked")
        // Start AR session
        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)

        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
                if true {
                    let anchor = AnchorEntity()
                    let parentEntity = ModelEntity()
                    let entity = try! Entity.load(named: "nature")
                    parentEntity.addChild(entity)
//                    anchor.scale = [3,3,3]
                    entity.position -= SIMD3(x: 0, y: 0, z: -5)
                    anchor.addChild(parentEntity)
                    print("DEBUG: \(entity.availableAnimations.count)")
                    arView.scene.addAnchor(anchor)
                    for anim in entity.availableAnimations {
                        print("DEBUG: hi")
                        entity.playAnimation(anim.repeat())
                    }
                    let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                    parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                    
                    
                    
                    let anchor2 = AnchorEntity()
                    let parentEntity2 = ModelEntity()
                    let entity2 = try! Entity.load(named: "nodding")
                    parentEntity.addChild(entity2)
                    anchor2.scale = [1,1,1]
                    anchor2.addChild(parentEntity2)
                    print("DEBUG: \(entity.availableAnimations.count)")
                    arView.scene.addAnchor(anchor2)
                    for anim in entity2.availableAnimations {
                        print("DEBUG: hi")
                        entity2.playAnimation(anim.repeat())
                    }
                    let entityBounds2 = entity.visualBounds(relativeTo: parentEntity)
                    parentEntity2.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                    
                    
                    
        }
        // Add the box anchor to the scene
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}



struct NatureView_Previews: PreviewProvider {
    static var previews: some View {
        NatureView()
    }
}
