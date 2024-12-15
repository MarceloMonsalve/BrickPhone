//
//  BrickPhoneWidget.swift
//  BrickPhoneWidget
//
//  Created by Marcelo Monsalve on 11/27/24.
//

import WidgetKit
import SwiftUI

let appGroupIdentifier = "group.sds.brainrot.BrickPhone"

struct AppLink: Codable {
    let name: String
    let urlScheme: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let defaultApps = [
            AppLink(name: "Messages", urlScheme: "messages://"),
            AppLink(name: "Spotify", urlScheme: "spotify://"),
            AppLink(name: "Maps", urlScheme: "maps://"),
            AppLink(name: "Books", urlScheme: "ibooks://"),
            AppLink(name: "Safari", urlScheme: "x-web-search://"),
            AppLink(name: "Clock", urlScheme: "shortcuts://run-shortcut?name=OpenClock")
        ]
        return SimpleEntry(date: Date(), apps: defaultApps)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        if let data = sharedDefaults?.data(forKey: "widgetApps"),
           let apps = try? JSONDecoder().decode([AppLink].self, from: data) {
            let entry = SimpleEntry(date: Date(), apps: apps)
            completion(entry)
        } else {
            completion(placeholder(in: context))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        let apps: [AppLink]
        
        if let data = sharedDefaults?.data(forKey: "widgetApps"),
           let decodedApps = try? JSONDecoder().decode([AppLink].self, from: data) {
            apps = decodedApps
        } else {
            apps = placeholder(in: context).apps
        }
        
        let entry = SimpleEntry(date: Date(), apps: apps)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let apps: [AppLink]
}

struct BrickPhoneWidgetEntryView : View {
    var entry: Provider.Entry
    
    func createDeeplink(for urlScheme: String) -> URL {
        var components = URLComponents()
        components.scheme = "brickphone"  // your app's custom URL scheme
        components.host = "sbs.brainrot.BrickPhone"  // your app's bundle ID
        components.path = "/open"
        components.queryItems = [
            URLQueryItem(name: "open", value: urlScheme)
        ]
        return components.url!
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(entry.apps.prefix(6), id: \.name) { app in
                Link(destination: createDeeplink(for: app.urlScheme)) {  // Changed this line
                    Text(app.name)
                        .font(.custom("HelveticaNeue", size: 26))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
        .background(Color(hex: "#242424"))
    }
}

struct BrickPhoneWidget: Widget {
    let kind: String = "BrickPhoneWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BrickPhoneWidgetEntryView(entry: entry)
                    .containerBackground(Color(hex: "#242424"), for: .widget)  // Dark background for iOS 17+
            } else {
                BrickPhoneWidgetEntryView(entry: entry)
                    .background(Color(hex: "#242424"))  // Dark background for older iOS
            }
        }
        .configurationDisplayName("Quick Launch")
        .description("Launch your favorite apps quickly.")
        .supportedFamilies([.systemLarge])
    }
}

// Helper extension to create Color from hex
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

#Preview(as: .systemLarge) {
    BrickPhoneWidget()
} timeline: {
    SimpleEntry(date: .now, apps: [
        AppLink(name: "Messages", urlScheme: "messages://"),
        AppLink(name: "Phone", urlScheme: "tel://"),
        AppLink(name: "Safari", urlScheme: "safari://"),
        AppLink(name: "Mail", urlScheme: "mailto://"),
        AppLink(name: "Maps", urlScheme: "maps://"),
        AppLink(name: "Settings", urlScheme: "app-settings://")
    ])
}
