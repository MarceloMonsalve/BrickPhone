import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry()], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
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
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            .sRGB,
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255,
            opacity: 1
        )
    }
}

#Preview(as: .systemSmall) {
    BlankWidget()
} timeline: {
    SimpleEntry()
}
