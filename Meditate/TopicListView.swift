//
//  TopicListView.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import SwiftUI

struct TopicListView : View {
    @ObservedObject var viewModel: TopicListViewModel
    
    init(_ viewModel: TopicListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                ForEach(viewModel.topics) { topic in
                    TopicCardView(topic)
                }
            }
            .padding()
        }
        .navigationTitle("Topics")
        .onAppear {
            viewModel.loadMeditationTopics()
        }
    }

    struct TopicCardView : View {
        private let topic: TopicListViewModel.TopicCard
        
        init(_ topic: TopicListViewModel.TopicCard) {
            self.topic = topic
        }
        
        var body : some View {
            NavigationLink(destination: topic.destination) {
                HStack {
                    Color(topic.color).frame(width: colorWidth)
                    VStack(alignment: .leading) {
                        Text(topic.title)
                            .font(.headline)
                        Text("\(topic.totalNumberOfMeditations) Meditations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderThickness))
            }
        }
        
        // MARK: - View Constants
        
        private let colorWidth: CGFloat = 12
        private let height: CGFloat = 80
        private let cornerRadius: CGFloat = 3
        private let borderColor: Color = .init(white: 0, opacity: 0.1)
        private let borderThickness: CGFloat = 1
        
    }
}

extension Color {
    init(_ topicColor: Topic.Color) {
        self.init(
            red: Double(topicColor.red) / 255.0,
            green: Double(topicColor.green) / 255.0,
            blue: Double(topicColor.blue) / 255.0)
    }
}

// MARK: - Preview

struct TopicListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicListView(.init(library: FakeMeditationLibrary()))
        }
    }
    
    class FakeMeditationLibrary : IMeditationLibrary {
        private var topicsSubject = PassthroughSubject<[Topic], Error>()
        
        var meditationTopics: AnyPublisher<[Topic], Error> {
            topicsSubject.eraseToAnyPublisher()
        }
        
        func loadMeditationTopics() {
            topicsSubject.send([
                ("Stress & Anxiety", Topic.Color(hex: "#507992")),
                ("Great for Beginners", Topic.Color(hex: "#148EC0")),
                ("Focus", Topic.Color(hex: "#406DA2")),
                ("Waking Up", Topic.Color(hex: "#30B3D8")),
                ("Happiness", Topic.Color(hex: "#5182DA")),
                ("Relationships", Topic.Color(hex: "#9A5AAF")),
                ("Difficult Emotions", Topic.Color(hex: "#616171")),
                ("Advanced & Unguided", Topic.Color(hex: "#ACBEC3")),
                ("On the Go", Topic.Color(hex: "#3EAC93")),
                ("Uncensored", Topic.Color(hex: "#22222A")),
                ("Health", Topic.Color(hex: "#599CC4"))
            ].enumerated().map { position, tuple in
                Topic(
                    id: UUID(),
                    title: tuple.0,
                    isFeatured: false,
                    isSubtopic: false,
                    position: position,
                    subtopics: [],
                    meditations: (0..<38).map { _ in UUID() },
                    color: tuple.1,
                    description: "",
                    parentID: nil)
            })
        }
        
        func meditations(for topic: Topic) -> AnyPublisher<[Meditation], Error> {
            Just<[Meditation]>([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
