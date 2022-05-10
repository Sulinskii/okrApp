//
//  CollectionViewCell.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct CollectionViewCell: View {
    let name: String
    var body: some View {
        Text(name)
            .font(.subheadline)
            .lineLimit(nil)
    }
}
