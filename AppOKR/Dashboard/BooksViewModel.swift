import Combine
import Foundation

final class BooksViewModel: ObservableObject {
    private let api: Api
    private var cancellationToken: AnyCancellable?
    
    @Published var books: [Book] = []
    @Published var podcasts: [Book] = []
    @Published var presentAlert: Bool = false
    
    init(api: Api = Api.shared) {
        self.api = api
    }

    
//    func retry() {
//        cancellationToken.ret
//    }
//
    func fetchBooks() {
        let booksApiCall = api.fetchBooks()
        let podcastsApiCall = api.fetchPodcasts()
        cancellationToken = Publishers.Zip(booksApiCall, podcastsApiCall)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("ERROR: \(error)")
                        self?.presentAlert = true
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] books, podcasts in
                    print("RECEIVED VALUE")
                    self?.books = books.feed.results
                    self?.podcasts = podcasts.feed.results
                })
    }
}
