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
        let useCase = MockBrowseMeditationsUseCase()
        let topics = (0..<10).map { _ in Topic.make() }
        useCase.meditationTopicsResult = .success(topics)
        let sut = TopicListViewModel(useCase: useCase)
        
        sut.loadMeditationTopics()
        
        XCTAssertTrue(useCase.didLoadMeditationTopics)
        XCTAssertEqual(topics.count, (try await(sut.$topics.dropFirst().eraseToAnyPublisher())).count)
    }
}
