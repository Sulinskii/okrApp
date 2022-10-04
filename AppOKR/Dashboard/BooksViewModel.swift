import Foundation
import CoreData

final class BooksViewModel: ObservableObject {
    private let api: Api
    private let viewContext: NSManagedObjectContext
    
    @Published var books: [Book] = []
    @Published var podcasts: [Book] = []
    @Published var presentAlert: Bool = false
    
    init(api: Api = Api.shared, viewContext: NSManagedObjectContext = CoreDataStack.viewContext) {
        self.api = api
        self.viewContext = viewContext
    }
    
    func fetchBooks(quantity: Int) {
        Task {
            do {
                let booksApiCall = try await api.fetchData(with: .books, quantity: 10)
                let podcastsApiCall = try await api.fetchData(with: .podcasts, quantity: 10)
            
                await updateValues(books: booksApiCall.feed.results,
                             podcasts: podcastsApiCall.feed.results)
            } catch {
                await MainActor.run {
                    presentAlert = true
                }
            }
        }
    }
    
    @MainActor
    private func updateValues(books: [Book], podcasts: [Book]) {
        books.forEach { book in
            BookObject.save(book: book, inViewContext: self.viewContext)
        }
        self.podcasts = podcasts
    }
}
