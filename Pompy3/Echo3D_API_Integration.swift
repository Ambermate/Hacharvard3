//
//  Echo3D_API_Integration.swift
//  Divhacks-2
//
//  Created by Brayton Lordianto on 9/23/22.
//

import Foundation

var models = [EchoModel]()

func getDataAsNSDict(api_key: String = "weathered-sun-1162", completion: @escaping (NSDictionary?) -> ()) {
    let urlString = "https://console.echoar.xyz/query?key=" + api_key
    guard let url = URL(string: urlString) else{ print("DEBUG: NO URL FOUND"); return }
    
    let sem = DispatchSemaphore.init(value: 0)
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        guard let data = data else { print("DEBUG: NO DATA FOUND"); return }
        
        do {
            let aDictionary : NSDictionary? = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            if let actualDictionary = aDictionary?["db"] as? NSDictionary {
                completion(actualDictionary)
            }
            
            else {
                print("no db")
                completion(nil)
            }
        } catch { completion(nil) }
        
        defer { sem.signal() }
    }
    
    task.resume()
    sem.wait()
}

func encodeIntoModel(_ data: NSDictionary?) {
    guard let data = data else { print("DEBUG: NO DICTIONARY COMPLETION"); return }
    
    let keys = data.allKeys
    for key in keys {
        let singleEntry = data[key]! as! NSDictionary
        
        // get data information as a data model
        guard
            let hologram = singleEntry["hologram"] as? NSDictionary,
            let filename = hologram["filename"] as? String,
            let storageID = hologram["storageID"] as? String,
            let id = key as? String
        else { print("DEBUG: NO FILE FOUND"); return }
        let additionalData = singleEntry["additionalData"] as? NSDictionary
        let description = additionalData?["entryComment"] as? String ?? "No Description"
        let data = EchoModel(id: id, filename: filename, storageFileID: storageID, description: description)
        
        // store that data into a result
        models.append(data)
        
    }
    
    // once everything is done, then give the signal
}
