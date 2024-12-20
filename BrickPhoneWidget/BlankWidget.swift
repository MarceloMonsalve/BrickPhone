//
//  BlankWidget.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/19/24.
//

import WidgetKit
import SwiftUI

struct BlankWidgetProvider: TimelineProvider {
    typealias Entry = BlankWidgetEntry
    
    func placeholder(in context: Context) -> BlankWidgetEntry {
        BlankWidgetEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (BlankWidgetEntry) -> ()) {
        completion(BlankWidgetEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BlankWidgetEntry>) -> ()) {
        let timeline = Timeline(entries: [BlankWidgetEntry()], policy: .never)
        completion(timeline)
    }
}

struct BlankWidgetEntry: TimelineEntry {
    let date: Date = Date()
}

struct BlankWidgetEntryView : View {
    var body: some View {
        Color(hex: "#242424")
            .ignoresSafeArea()
    }
}

struct BlankWidget: Widget {
    let kind: String = "BlankWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BlankWidgetProvider()) { _ in
            if #available(iOS 17.0, *) {
                BlankWidgetEntryView()
                    .containerBackground(Color(hex: "#242424"), for: .widget)
            } else {
                BlankWidgetEntryView()
                    .padding(0)
                    .background(Color(hex: "#242424"))
            }
        }
        .configurationDisplayName("Blank Widget")
        .description("A solid color widget.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    BlankWidget()
} timeline: {
    BlankWidgetEntry()
}
