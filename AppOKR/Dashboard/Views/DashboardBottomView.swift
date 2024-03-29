//
//  DashboardBottomView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 09/05/2022.
//

import Foundation
import SwiftUI
import FirebaseAnalytics

struct DashboardBottomView: View {
    
    @Binding var numberOfBooksFetched: Int
    
    var action: () -> ()
    
    var body: some View {
        VStack {
            Button("Fetch next 10 books") {
                Analytics.logEvent("button_selected", parameters: nil)
                action()
            }
            
            Text("Already fetched books: \(numberOfBooksFetched)")
        }
    }
}
