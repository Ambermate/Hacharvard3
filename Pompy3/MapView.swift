//
//  MapView.swift
//  Pompy3
//
//  Created by Brayton Lordianto on 10/16/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: "https://brayton-lordianto.github.io/hackharvard-map/")!)
        webView.load(request)
    }
}

struct MapView: View {
    var body: some View {
        WebView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
