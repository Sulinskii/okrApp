//
//  BackgroundColorKey.swift
//  AppOKR
//
//  Created by Artur Sulinski on 10/05/2022.
//

import Foundation
import SwiftUI

private struct BackgroundColorKey: EnvironmentKey {    
    static let defaultValue = Color.red
}

extension EnvironmentValues {
  var appBackgroundColor: Color {
    get { self[BackgroundColorKey.self] }
    set { self[BackgroundColorKey.self] = newValue }
  }
}
