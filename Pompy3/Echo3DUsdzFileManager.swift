//
//  Echo3DUsdzFileManager.swift
//  Divhacks-2
//
//  Created by Brayton Lordianto on 9/23/22.
//

import Foundation
import RealityKit
import ARKit

class EchoUsdzFileManager {
    static var directoryPath: URL {
        try! FileManager.default.url(for: .documentDirectory,in: .userDomainMask,appropriateFor: nil,create: false)
    }
    
    static func getAsModelEntity(_ name: String) -> ModelEntity? {
        guard let entity = getUsdzEntity(name) else { print("DEBUG: failed to fetch entity. "); return nil }
        
        // Scaling entity to a reasonable size
        entity.generateCollisionShapes(recursive: true)
       
        // Creating parent ModelEntity
        let parentEntity = ModelEntity()
        parentEntity.addChild(entity)
              
        // Playing availableAnimations on repeat
//        entity.availableAnimations.forEach { entity.playAnimation($0.repeat()) }
       
        // Add a collision component to the parentEntity with a rough shape and appropriate offset for the model that it contains
        let entityBounds = entity.visualBounds(relativeTo: parentEntity)
        parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])

        return parentEntity
    }
    
    static func getPathIfExists(fileName: String) -> (URL, Bool) {
        // setup the url to save in
        let savedPath = directoryPath
            .appendingPathComponent(fileName)
        
        // clear the temp first
        FileManager.default.clearTmpDirectory()
        
        // check if already exists
        print("DEBUG: searching for " + savedPath.description)
        let fileDoesExist = FileManager.default.fileExists(atPath: savedPath.path)
        if fileDoesExist { print("DEBUG: " + fileName + " exists"); return (savedPath, true) }
        print("DEBUG: \(fileName) is not found/cached")
        
        return (savedPath, false)
    }

    static func getUsdzEntity(_ name: String) -> Entity? {
        let tuple = getPathIfExists(fileName: name)
        
        // if exists, create a entity with the loaded url
        // if not, download the file
        if !tuple.1 { downloadOne(name: name) }
        do {
            let entity = try Entity.load(contentsOf: tuple.0)
            print("DEBUG: success loading \(name)")
            return entity
        } catch { print("DEBUG: error loading \(name)") }
        
        return nil
    }
    
    static func downloadOne(name: String, urlString: String = "https://console.echoar.xyz/query?key=weathered-sun-1162&file=") {
        let urlString = urlString + name
        
        // add a sem
        let sem = DispatchSemaphore.init(value: 0)
        
        // check if it is a usdz
        guard urlString.hasSuffix(".usdz"), let url = URL(string: urlString)
            else { print("DEBUG: no usdz file for ](urlString"); return }
        print("DEBUG: \(urlString) found online")
        
        // get the path url and only continue if it is not cached
        let tuple = getPathIfExists(fileName: name)
        let fileExists = tuple.1
        guard !fileExists else { print("DEBUG: FILE ALREADY EXISTS. DOWNLOADING SKIPPED."); return }
        let savedPath = tuple.0
        
        // download from the net
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            defer { sem.signal() }
            
            // handle actual downloading
            guard let fileURL = urlOrNil else { return }
            do {
                print("DEBUG: loading image at " + savedPath.description)
                try FileManager.default.moveItem(at: fileURL, to: savedPath)
                print("DEBUG: File exists at " + savedPath.description)
            } catch { print ("DEBUG: File Error: \(error)") }
        }
        downloadTask.resume()
        
        sem.wait()
    }
}

extension FileManager {
    // clear temp so there are no conflicts with the temporary directory
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            //let docDirectory = try contentsOfDirectory(atPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
            /*try docDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }*/
            
        } catch {
            print(error)
        }
    }
}
