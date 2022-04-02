//
//  BookDetails.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI
import WebKit
import Combine

struct BookDetails: View {
    private let viewModel = BookDetailsViewModel()
    
    @State private var isActive = false
    
    let book: Book
    let action = PassthroughSubject<String, Never>()
    
    var body: some View {
        Text(book.releaseDate)
        Button("Website") {
            isActive = true
        }
        
        Button("Do action") {
            action.send("Big action")
        }
        .navigationTitle(book.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.updateWidgetData(with: book.name)
        }
    }
}


struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL
    
    init(urlString: String) {
        webView = WKWebView(frame: .zero)
        url = URL(string: urlString)!

        loadUrl()
    }
    
    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
}
