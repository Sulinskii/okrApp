//
//  BookListCellViewModel.swift
//  AppOKR
//
//  Created by Artur Sulinski on 20/03/2022.
//

import Foundation
import WidgetKit

struct BookDetailsViewModel {
    
    private let spotifyService = SpotifyService()
    
    func didTapConnect() {
        spotifyService.connect()
    }
    
    func updateWidgetData(with bookName: String) {
        guard let userDefaults = UserDefaults(suiteName: "group.AppOKR") else { return }
        var widgetDictionary = [String: Any]()
        widgetDictionary["Date"] = Date()
        widgetDictionary["BookName"] = bookName
        userDefaults.set(widgetDictionary, forKey: "WidgetKey")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
