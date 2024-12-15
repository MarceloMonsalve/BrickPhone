//
//  AppStorage.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/12/24.
//


import Foundation
import WidgetKit

@MainActor
class AppStorage {
    static let shared = AppStorage()
    
    private let userDefaults: UserDefaults?
    
    private init() {
        userDefaults = UserDefaults(suiteName: Constants.appGroupIdentifier)
    }
    
    func saveApps(_ apps: [AppLink]) {
        guard let encoded = try? JSONEncoder().encode(apps) else { return }
        userDefaults?.set(encoded, forKey: Constants.widgetAppsKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func loadApps() -> [AppLink] {
        guard let data = userDefaults?.data(forKey: Constants.widgetAppsKey),
              let apps = try? JSONDecoder().decode([AppLink].self, from: data)
        else { return [] }
        return apps
    }
}
