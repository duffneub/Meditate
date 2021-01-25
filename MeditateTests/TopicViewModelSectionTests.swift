//
//  TopicViewModelSectionTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest
@testable import Meditate

class TopicViewModelSectionTests: CombineTestCase {
    private let library = MockMeditationLibrary()

    func testTitle_shouldMatchTopicTitle() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section(topic, library: library)
        
        XCTAssertEqual(topic.title, sut.title)
    }
    
    func testTitle_withGenericSection_shouldBeMeditations() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section.generic(topic, library: library)
        
        XCTAssertEqual("Meditations", sut.title)
    }
    
    func testMeditations_shouldGetMeditationsFromLibrary() {
        let meditations = (0..<10).map { _ in Meditation.make() }
        let topic = Topic.make(meditations: meditations.map { $0.id })
        library.setMeditations(for: topic, to: .success(meditations))
        let sut = TopicViewModel.Section(topic, library: library)
        sut.loadMeditations()
        
        XCTAssertEqual(meditations, try await(sut.$meditations.dropFirst().eraseToAnyPublisher()))
    }
    
}
