//
//  ContentView.swift
//  HackHarvard
//
//  Created by Brayton Lordianto on 10/14/22.
//

import SwiftUI
import Foundation
import RealityKit
import ARKit
import Combine

struct ContentView : View {
    var body: some View {
//        BasicPompiView()
//        NatureView()
        MapView()
    }
//    var changed = PassthroughSubject<String, Never>()
//    
////    var view: ARViewContainer {
////        ARViewContainer(theName: text)
////    }
//    var body: some View {
//        ZStack {
//            ARViewContainer(didChange: changed)
//            .edgesIgnoringSafeArea(.all)
//
////            Button {
////                print("pressed")
////                self.changed.send("jump1")
////            } label: {
////                Text("hi there")
////            }
//            
//            buttonsOnAR(text: changed)
//
//            
//        }
//    }
}

struct ARViewContainer: UIViewRepresentable {
    var didChange: PassthroughSubject<String, Never>
    @State var cancellable: AnyCancellable? = nil

    init(didChange: PassthroughSubject<String, Never>) {
        self.didChange = didChange
    }
    
    func makeUIView(context: Context) -> ARView {
        print("Called here")
        let arView = ARView(frame: .zero)
//        print("DEBUG:: ")
//        print("DEBUG: worked")
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        DispatchQueue.main.async {
            self.cancellable = didChange.sink { (value) in
                if value != "" {
                    let anchor = AnchorEntity()
                    let parentEntity = ModelEntity()
                    let entity = try! Entity.load(named: value)
                    parentEntity.addChild(entity)
                    anchor.scale = [10,10,10]
                    anchor.addChild(parentEntity)
                    print("DEBUG: \(entity.availableAnimations.count)")
                    arView.scene.addAnchor(anchor)
                    for anim in entity.availableAnimations {
                        print("DEBUG: hi")
                        entity.playAnimation(anim.repeat())
                    }
                    let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                    parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                    
                    arView.installGestures(for: parentEntity)
                }
            }
        }
        // Add the box anchor to the scene
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
