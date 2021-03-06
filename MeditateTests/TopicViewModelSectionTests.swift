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
    private let useCase = MockBrowseMeditationsUseCase()

    func testTitle_shouldMatchTopicTitle() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section(topic, useCase: useCase)
        
        XCTAssertEqual(topic.title, sut.title)
    }
    
    func testTitle_withGenericSection_shouldBeMeditations() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section.generic(topic, useCase: useCase)
        
        XCTAssertEqual("Meditations", sut.title)
    }
    
    func testMeditations_shouldGetMeditationsFromLibrary() {
        let meditations = (0..<10).map { _ in Meditation.make() }
        let topic = Topic.make(meditations: meditations.map { $0.id })
        useCase.setMeditations(for: topic, to: .success(meditations))
        let sut = TopicViewModel.Section(topic, useCase: useCase)
        sut.loadMeditations()
        
        XCTAssertEqual(meditations, try await(sut.$meditations.dropFirst().eraseToAnyPublisher()))
    }
    
}
