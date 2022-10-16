//
//  BasicPompiView.swift
//  Pompy3
//
//  Created by Brayton Lordianto on 10/15/22.
//

import SwiftUI
import Foundation
import RealityKit
import ARKit
import Combine


struct BasicPompiView: View {
    var didChange = CurrentValueSubject<String, Never>("jump1")
    var body: some View {
        PompiARView(didChange: self.didChange)
            .onTapGesture {
                print("DEBUG: tap")
                self.didChange.send("nodding")
            }
            .onLongPressGesture {
                print("DEBUG: long press")
                self.didChange.send("jump2")
            }
            .onAppear {
                self.didChange.send("jump1")
            }
            .ignoresSafeArea()
    }
}

struct PompiARView: UIViewRepresentable {
    var didChange: CurrentValueSubject<String, Never>
    @State var cancellable: AnyCancellable? = nil
    @State var prevAnchor = AnchorEntity(world: [0, 0,-1])
    @State var prevPosition = SIMD3<Float>(x: 5, y: 5, z: 5)

    
    init(didChange: CurrentValueSubject<String, Never>) {
        self.didChange = didChange
    }
    
    func makeUIView(context: Context) -> ARView {
        print("Called here")
        let arView = ARView(frame: .zero)
        
        
        DispatchQueue.main.async {
            self.cancellable = didChange.sink { (value) in
                print("DEBUG: did change is ", value)
                if value != "" {
                    arView.scene.removeAnchor(prevAnchor)
                    
                    
                    prevPosition = prevAnchor.position
                    let anchor = AnchorEntity()
                    let parentEntity = ModelEntity()
//                    parentEntity.position += prevPosition
                    let entity = try! Entity.load(named: value)
                    parentEntity.addChild(entity)
                    anchor.scale = [0.1,0.1,0.1]
                    anchor.addChild(parentEntity)
                    print("DEBUG: \(entity.availableAnimations.count)")
                    arView.scene.addAnchor(anchor)
                    
                    for anim in entity.availableAnimations {
                        print("DEBUG: hi")
                        if value == "jump1" {
                            entity.playAnimation(anim.repeat())
                        } else if value == "jump2" {
                            entity.playAnimation(anim)
                        } else {
                            entity.playAnimation(anim.repeat(count: 3))
                        }
//                        entity.playAnimation(value != "jump2" ? anim.repeat() : anim)
                    }
                    let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                    parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                    
                    arView.installGestures(for: parentEntity)
                    prevAnchor = anchor
                    prevPosition = parentEntity.position
                    
                    if value != "jump1" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.didChange.send("jump1")
                            
                        }

                    }
                    print("debug: prev pos ", prevPosition, " ", anchor.position, " ", entity.position)
                }
            }
        }
        // Add the box anchor to the scene
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}


struct BasicPompiView_Previews: PreviewProvider {
    static var previews: some View {
        BasicPompiView()
    }
}
