import Combine
import Foundation

final class BooksViewModel: ObservableObject {
    private let api: Api
    private var cancellationToken: AnyCancellable?
    
    @Published var books: [Book] = []
    @Published var podcasts: [Book] = []
    @Published var presentAlert: Bool = false
    
    init(api: Api = Api()) {
        self.api = api
        fetchDogsFacts()
    }

    func fetchDogsFacts() {
        let booksApiCall = api.fetchBooks()
        let podcastsApiCall = api.fetchPodcasts()
        cancellationToken = Publishers.Zip(booksApiCall, podcastsApiCall)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure:
                        self?.presentAlert = true
                    case .finished:
                        print("DONE - postUserPublisher")
                    }
                }, receiveValue: { [weak self] books, podcasts in
                    self?.books = books.feed.results
                    self?.podcasts = podcasts.feed.results
                    print("PODCASTS: \(self?.podcasts)")
                })
    }
}
