//
//  TopicListViewModelTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest
@testable import Meditate

class TopicListViewModelTests: CombineTestCase {
    func testLoadMeditationTopics_shouldGetTopicsFromLibrary() throws {
        let library = MockMeditationLibrary()
        let topics = (0..<10).map { _ in Topic.make() }
        library.meditationTopicsResult = .success(topics)
        let sut = TopicListViewModel(library: library)
        
        sut.loadMeditationTopics()
        
        XCTAssertTrue(library.didLoadMeditationTopics)
        XCTAssertEqual(topics.count, (try await(sut.$topics.dropFirst().eraseToAnyPublisher())).count)
    }
}
