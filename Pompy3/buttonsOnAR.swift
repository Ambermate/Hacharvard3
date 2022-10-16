//
//  buttonsOnAR.swift
//  Pompy3
//
//  Created by Brayton Lordianto on 10/15/22.
//

import SwiftUI
import Combine

struct buttonsOnAR: View {
    var text: PassthroughSubject<String, Never>
    var body: some View {
        VStack {
            Button {
                self.text.send("paris")
            } label: {
                Text("button 1 - travel ")
            }
            
            Button {
                
            } label: {
                Text("button 2")
            }
            
            Button {
                
            } label: {
                Text("button 3")
            }

        }

    }
}

//struct buttonsOnAR_Previews: PreviewProvider {
//    static var previews: some View {
//        buttonsOnAR()
//    }
//}
