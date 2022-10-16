

import Foundation

struct TestItem: Codable {
    var sometext: String
}
    
func post(to urlString: String, _ data: TestItem) {
    guard let url = URL(string: urlString) else{return}
    
    do {
        let data = try? JSONEncoder().encode(data)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // based on this, it seems to work
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            print(String(data: data!, encoding: .utf8)!)
            print(response ?? "no")
            print(error ?? "none")
            
            // change the state
            
        }
        task.resume()
    }
    
}

//post(to: "https://3dc0-65-112-8-20.ngrok.io/test_post", TestItem(sometext: "https://www.dropbox.com/s/swk13j8d44ohwgg/IMG_7441.jpg?dl=1"))
