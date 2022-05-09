//
//  BookObject+.swift
//  AppOKR
//
//  Created by Artur Sulinski on 08/05/2022.
//

import Foundation
import CoreData

extension BookObject {
    
    static func save(book: Book, inViewContext viewContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookObject.self))
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", book.id)
        
        if let results = try? viewContext.fetch(fetchRequest),
           let existing = results.first as? BookObject {
            existing.url = book.url
            existing.name = book.name
            existing.kind = book.kind
            existing.artistId = book.artistId
            existing.artistUrl = book.artistUrl
            existing.artistName = book.artistName
            existing.releaseDate = book.releaseDate
        } else {
            let newBook = self.init(context: viewContext)
            newBook.id = book.id
            newBook.url = book.url
            newBook.name = book.name
            newBook.kind = book.kind
            newBook.artistId = book.artistId
            newBook.artistUrl = book.artistUrl
            newBook.artistName = book.artistName
            newBook.releaseDate = book.releaseDate
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    static func delete(inViewContext viewContext: NSManagedObjectContext) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookObject.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
