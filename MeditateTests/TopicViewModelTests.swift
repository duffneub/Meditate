//
//  TopicViewModelTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import XCTest
@testable import Meditate

class TopicViewModelTests: XCTestCase {
    
    // MARK: - Title

    func testTitle_shouldMatchTopicTitle() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel(topic, library: MockMeditationLibrary())
        
        XCTAssertEqual(topic.title, sut.title)
    }
    
    // MARK: - Description
    
    func testDescription_shouldMatchTopicDescription() {
        let topic = Topic.make(description: "A description")
        let sut = TopicViewModel(topic, library: MockMeditationLibrary())
        
        XCTAssertEqual(topic.description, sut.description)
    }
    
    // MARK: - Meditation Sections
    
    func testMeditationSections_shouldIncludeSubtopicsAndGeneralMeditationsSection() {
        let subtopics = (0..<10).map { _ in Topic.make(meditations: [UUID()]) }
        let topic = Topic.make(subtopics: subtopics, meditations: [UUID()])
        let sut = TopicViewModel(topic, library: MockMeditationLibrary())
        
        let sections = sut.meditationSections
        
        XCTAssertEqual(subtopics.count + 1, sections.count)
        subtopics.enumerated().forEach { index, subtopic in
            XCTAssertEqual(subtopic.title, sections[index].title)
        }
        XCTAssertEqual("Meditations", sections[subtopics.count].title)
    }
    
    func testMeditationSections_withNoSubtopics_shouldJustIncludeGeneralMeditationsSection() {
        let topic = Topic.make(meditations: [UUID()])
        let sut = TopicViewModel(topic, library: MockMeditationLibrary())
        
        let sections = sut.meditationSections
        
        XCTAssertEqual(1, sections.count)
        XCTAssertEqual("Meditations", sections[0].title)
    }
    
    func testMeditationSections_withNoMeditations_shouldJustIncludeSubtopicSections() {
        let subtopics = (0..<10).map { _ in Topic.make(meditations: [UUID()]) }
        let topic = Topic.make(subtopics: subtopics)
        let sut = TopicViewModel(topic, library: MockMeditationLibrary())
        
        let sections = sut.meditationSections
        
        XCTAssertEqual(subtopics.count, sections.count)
        subtopics.enumerated().forEach { index, subtopic in
            XCTAssertEqual(subtopic.title, sections[index].title)
        }
    }
    
}
