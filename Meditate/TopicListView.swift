//
//  TopicListView.swift
//  Meditate
//
//  Created by Duff Neubauer on 1/24/21.
//

import SwiftUI

struct TopicListView : View {
    private let topics: [Topic]
    
    init(topics: [Topic]) {
        self.topics = topics
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                ForEach(topics) { topic in
                    TopicCardView(topic: topic)
                }
            }
            .padding()
        }
        .navigationTitle("Topics")
    }
}

struct TopicCardView : View {
    let topic: Topic
    
    var body : some View {
        HStack {
            Color.red.frame(width: colorWidth)
            VStack(alignment: .leading) {
                Text(topic.title)
                    .font(.headline)
                Text("\(topic.numberOfMeditations) Meditations")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: borderThickness))
    }
    
    // MARK: - View Constants
    
    private let colorWidth: CGFloat = 12
    private let height: CGFloat = 80
    private let cornerRadius: CGFloat = 3
    private let borderColor: Color = .init(white: 0, opacity: 0.1)
    private let borderThickness: CGFloat = 1
    
}

struct TopicListView_Previews: PreviewProvider {
    static let topics: [Topic] = [
        "Stress & Anxiety",
        "Great for Beginners",
        "Focus",
        "Waking Up",
        "Happiness",
        "Relationships",
        "Difficult Emotions",
        "Advanced & Unguided",
        "On the Go",
        "Uncensored",
        "Health"
    ].enumerated().map { position, title in
        Topic.init(
            id: UUID(),
            title: title,
            isFeatured: false,
            isSubtopic: false,
            position: position,
            subtopics: [],
            meditations: (0..<38).map { _ in UUID() })}

    static var previews: some View {
        NavigationView {
            TopicListView(topics: topics)
        }
    }
}
