//
//  AppOKRWidgetViewModel.swift
//  AppOKRWidgetExtension
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation


struct AppOKRWidgetViewModel {
    private let userDefaults = UserDefaults(suiteName: "group.AppOKR")
    
    func getEntry() -> AppOKRWidgetEntry {
        let dictionary: [String: Any] = userDefaults?.dictionary(forKey: "WidgetKey") ?? [:]
        let date: Date = dictionary["Date"] as? Date ?? Date()
        let bookName: String = dictionary["BookName"] as? String ?? ""
        return AppOKRWidgetEntry(date: date, subtitle: bookName)
    }
}
