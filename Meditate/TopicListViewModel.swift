//
//  TopicListViewModel.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

class TopicListViewModel : ObservableObject {
    let library: IMeditationLibrary
    private var subscriptions = Set<AnyCancellable>()
    @Published var topics: [Topic] = []
    
    init(library: IMeditationLibrary) {
        self.library = library
        self.library.meditationTopics
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.topics, on: self)
            .store(in: &subscriptions)
    }
    
    func loadMeditationTopics() {
        library.loadMeditationTopics()
    }
}
