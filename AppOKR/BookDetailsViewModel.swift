//
//  BookListCellViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import WidgetKit

struct BookDetailsViewModel {
    func updateWidgetData(with bookName: String) {
        guard let userDefaults = UserDefaults(suiteName: "group.com.appokr.AppOKR") else { return }
        userDefaults.set(bookName, forKey: "WidgetKey")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
