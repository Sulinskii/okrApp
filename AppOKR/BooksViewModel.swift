//protocol BooksViewModelProtocol: AnyObject {
//    var viewController: DashboardViewController? { get set }
//}

import Combine

final class BooksViewModel: ObservableObject {

//    weak var viewControlle÷r: DashboardViewController?
    private let api: Api
    private var cancellationToken: AnyCancellable?

    init(api: Api = Api()) {
        self.api = api
        fetchDogsFacts()
    }

    private func fetchDogsFacts() {
        cancellationToken = api.fetchBooks()
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .failure(let error):
                        print("ERROR \(error)")
                    case .finished:
                        print("DONE - postUserPublisher")
                    }
                }, receiveValue: { dog in
                    print("RECEIVED VALUE: \(dog)")
                })
    }
}
