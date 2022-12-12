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
    @State private var intValue = 0
    
    let book: BookObject
//    let action = PassthroughSubject<String, Never>()
//    let action2 = CurrentValueSubject<String, Never>("Test")
    
    var body: some View {
        Text("Release date: \(book.releaseDate ?? "")")
        Button("Connect") {
            viewModel.didTapConnect()
        }
        
//        Button("Do action") {
//            action.send("Big action")
//        }
//
//        Button("Create future publisher") {
//            createFuture()
//        }
//
//        Button("Observe on future \(intValue)") {
//            observeOnFuture()
//        }
        
        .navigationTitle(book.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.updateWidgetData(with: book.name ?? "")
        }
    }
    
    func observeOnFuture() {
        createFuture().sink(receiveValue: { value in
            intValue = value
            print("RECEIVED VALUE: \(value)")
        })
        
    }
    
    func createFuture() -> AnyPublisher<Int, Never>  {
        
            Future { promise in
              print("Closure executed")
                promise(.success(Int.random(in: 1..<10)))
            }.eraseToAnyPublisher()
    }
    
    func performAsyncAction() -> Future <Bool, Never> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                return promise(.success(true))
            }
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
