import Foundation
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

final class BooksViewModel: ObservableObject {
    private let api: Api
    private let viewContext: NSManagedObjectContext
    private let db = Firestore.firestore()
    private let booksCollectionName = "Books"
    
    private var cancellables = Set<AnyCancellable>()
    
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
        let collection = db.collection(booksCollectionName)
        books.forEach { book in
            collection.document(book.id).setData(from: book)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { _ in
                    self.saveBook(with: book.id, for: collection)
                })
                .store(in: &cancellables)
        }
        
        self.podcasts = podcasts
    }
    
    private func saveBook(with id: String, for collection: CollectionReference) {
        collection.document(id).getDocument(as: Book.self) { result in
            switch result {
            case .success(let book):
                BookObject.save(book: book, inViewContext: self.viewContext)
            case .failure(let error):
                print("Error decoding book: \(error)")
                self.presentAlert = true
            }
        }
    }
}
