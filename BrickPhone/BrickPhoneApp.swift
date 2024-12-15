//
//  BrickPhoneApp.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 11/27/24.
//

import SwiftUI
import SwiftData

@main
struct BrickPhoneApp: App {
    @State private var isURLProxy = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPrivacyScreenShown = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(isURLProxy: $isURLProxy)
                    .background(Color(hex: "242424"))
                    .ignoresSafeArea()
                    .onOpenURL { url in
                        isURLProxy = true
                        handleURL(url)
                    }
                if isPrivacyScreenShown {
                    Color(hex: "242424")
                        .ignoresSafeArea()
                        .zIndex(999)
                }
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active:
                    isPrivacyScreenShown = false
                case .inactive, .background:
                    isPrivacyScreenShown = true
                @unknown default:
                    break
                }
            }
            
        }
    }
    
    func handleURL(_ url: URL) {
        guard url.scheme == "brickphone",
              url.host == "sbs.brainrot.BrickPhone"
        else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let urlToOpen = queryItems.first(where: { $0.name == "open" })?.value,
              let finalURL = URL(string: urlToOpen)
        else { return }
        
        Task {
            await UIApplication.shared.open(finalURL)
        }
        
        Task {
            try? await Task.sleep(for: .milliseconds(2000))
            isURLProxy = false
        }
    }
}
