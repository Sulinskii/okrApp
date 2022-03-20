//
//  AppOKRWidgetViewModel.swift
//  AppOKRWidgetExtension
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation


struct AppOKRWidgetViewModel {
    private let userDefaults = UserDefaults(suiteName: "group.com.appokr.AppOKR")
    
    func getData() -> String {
        userDefaults?.string(forKey: "WidgetKey") ?? "bbbb"
    }
}
