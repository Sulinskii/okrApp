//
//  CollectionView.swift
//  AppOKR
//
//  Created by Artur Sulinski on 06/01/2022.
//

import SwiftUI

struct CollectionView: View {
    let itemPerRow: CGFloat = 2
    let horizontalSpacing: CGFloat = 16
    let height: CGFloat = 100
    
    let books: [BookObject]
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<books.count) { i in
                        if i % Int(itemPerRow) == 0 {
                            buildView(rowIndex: i, geometry: geometry)
                        }
                    }
                }
            }
        }
    }
    
    func buildView(rowIndex: Int, geometry: GeometryProxy) -> RowView? {
        var rowBooks = [BookObject]()
        for itemIndex in 0..<Int(itemPerRow) {
            if rowIndex + itemIndex < books.count {
                rowBooks.append(books[rowIndex + itemIndex])
            }
        }
        if !rowBooks.isEmpty {
            return RowView(books: rowBooks, width: getWidth(geometry: geometry), height: height, horizontalSpacing: horizontalSpacing)
        }
            
        return nil
    }
    
    func getWidth(geometry: GeometryProxy) -> CGFloat {
            let width: CGFloat = (geometry.size.width - horizontalSpacing * (itemPerRow + 1)) / itemPerRow
            return width
        }
}
