//
//  ContentView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, Artur you are the best!")
            .font(.title2)
            .fontWeight(.light)
            .foregroundColor(.green)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
