//
//  AppGroup.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/03/2022.
//

import Foundation

import Foundation

public enum AppGroup: String {
  case facts = "group.com.appokr.AppOKR"

  public var containerURL: URL {
    switch self {
    case .facts:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
