//
//  Echo3DModel.swift
//  Divhacks-2
//
//  Created by Brayton Lordianto on 9/23/22.
//

import Foundation
class EchoViewModel: ObservableObject {
    @Published var echoModels = [EchoModel]()
    
    // easy access if needed
    var echoModelNames: [String] { echoModels.map { $0.name } }
    var echoModelPaths: [URL] { echoModels.map { $0.pathToDownloaded } }
    var fileNameTostorageID = [String:String]()
    
    init() {
        // load all the models
        getDataAsNSDict(completion: encodeIntoModel)
        self.echoModels = models
        // load file name to storage map
        for model in echoModels {
            fileNameTostorageID[model.filename] = model.storageFileID
        }
    }
}

struct EchoModel: Identifiable {
    var id: String
    var name: String {
        guard filename.hasSuffix(".usdz") else { return "No USDZ File" }
        let suffixIndex = filename.index(filename.endIndex, offsetBy: -5)
        return filename.prefix(upTo: suffixIndex).replacingOccurrences(of: "_", with: " ")
    }
    let filename: String
    let storageFileID: String
    let description: String
    var pathToDownloaded: URL {
        EchoUsdzFileManager.getPathIfExists(fileName: self.filename).0
    }
}
