//
//  TabDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Combine
import Foundation

class TabDetailFetcher: ObservableObject {
    @Published private(set) var topics: [Topic] = []

    @Published private(set) var isFetching: Bool = false

    private let topicTab: String

    private var cancellable: AnyCancellable?

    init(topicTab: String) {
        self.topicTab = topicTab
    }

    func cancel() {
        isFetching = false
        cancellable?.cancel()
    }

    func fetch() {
        cancel()
        guard topicTab == "all" else {
            return
        }

        isFetching = true
        let url = URL(string: "https://www.v2ex.com/api/topics/latest.json")!
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .tryMap { try JSONDecoder().decode([Topic].self, from: $0) }
            .sink { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] topics in
                self?.topics = topics
            }
    }
}
