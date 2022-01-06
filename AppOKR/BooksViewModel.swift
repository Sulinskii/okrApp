//protocol BooksViewModelProtocol: AnyObject {
//    var viewController: DashboardViewController? { get set }
//}

import Combine
import Foundation
import SwiftUI

final class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var presentAlert: Bool = false
    private let api: Api
    private var cancellationToken: AnyCancellable?

    init(api: Api = Api()) {
        self.api = api
        fetchDogsFacts()
    }

    func fetchDogsFacts() {
        cancellationToken = api.fetchBooks()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure:
                        self?.presentAlert = true
                    case .finished:
                        print("DONE - postUserPublisher")
                    }
                }, receiveValue: { [weak self] resultData in
                    self?.books = resultData.feed.results
                })
    }
}
