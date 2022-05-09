import Combine
import Foundation
import CoreData

final class BooksViewModel: ObservableObject {
    private let api: Api
    private let viewContext: NSManagedObjectContext 
    private var cancellationToken = Set<AnyCancellable>()
    
    @Published var books: [Book] = []
    @Published var podcasts: [Book] = []
    @Published var presentAlert: Bool = false
    
    init(api: Api = Api.shared, viewContext: NSManagedObjectContext = CoreDataStack.viewContext) {
        self.api = api
        self.viewContext = viewContext
    }
    
    func fetchBooks(quantity: Int) {
        let booksApiCall = api.fetchBooks(quantity)
        let podcastsApiCall = api.fetchPodcasts()
        Publishers.Zip(booksApiCall, podcastsApiCall)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("ERROR: \(error)")
                        self?.presentAlert = true
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] books, podcasts in
                    guard let self = self else { return }
                    books.feed.results.forEach { book in
                        BookObject.save(book: book, inViewContext: self.viewContext)
                    }
                    
//                    self?.books = books.feed.results
//                    self?.podcasts = podcasts.feed.results
                }).store(in: &cancellationToken)
        
        
    }
}
