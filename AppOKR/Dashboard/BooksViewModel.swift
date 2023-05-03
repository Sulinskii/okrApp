import Foundation
import CoreData

final class BooksViewModel: ObservableObject {
    private let api: Api
    private let viewContext: NSManagedObjectContext
    private let spotifyService = SpotifyService()
    
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
                let booksApiCall = try await api.fetchData(with: .books, quantity: quantity)
                let podcastsApiCall = try await api.fetchData(with: .podcasts, quantity: quantity)
            
                await updateValues(books: booksApiCall.feed.results,
                             podcasts: podcastsApiCall.feed.results)
            } catch {
                await MainActor.run {
                    presentAlert = true
                }
            }
        }
    }
    
    func fetchSpotifyAuthToken() {
        spotifyService.fetchAccessToken { (dictionary, error) in
            if let error = error {
                print("SPOTIFY ERROR: \(error)")
            }
//            let accessToken = dictionary!["access_token"] as! String
            print("SPOTIFY ACCESS TOKEN: \(dictionary)")
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
