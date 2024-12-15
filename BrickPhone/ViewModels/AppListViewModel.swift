//
//  AppListViewModel.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/12/24.
//

import Foundation
import SwiftUI

@MainActor
class AppListViewModel: ObservableObject {
    @Published var apps: [AppLink] = []
    @Published var searchText = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    var filteredSuggestions: [String] {
        guard !searchText.isEmpty else { return [] }
        return AppDatabase.knownApps.keys
            .filter { $0.lowercased().contains(searchText.lowercased()) }
            .filter { appName in
                !apps.contains(where: { $0.name == appName })
            }
    }
    
    init() {
        loadApps()
    }
    
    func loadApps() {
        apps = AppStorage.shared.loadApps()
    }
    
    func addApp(_ name: String) {
        guard apps.count < 6 else {
            alertMessage = "Maximum 6 apps allowed"
            showingAlert = true
            return
        }
        
        if let urlScheme = AppDatabase.knownApps[name] {
            apps.append(AppLink(name: name, urlScheme: urlScheme))
            AppStorage.shared.saveApps(apps)
        }
    }
    
    func addCustomApp() {
        guard apps.count < 6 else {
            alertMessage = "Maximum 6 apps allowed"
            showingAlert = true
            return
        }
        
        let appName = searchText.trimmingCharacters(in: .whitespaces)
        if AppDatabase.knownApps[appName] == nil {
            let urlScheme = AppDatabase.generateShortcutScheme(for: appName)
            apps.append(AppLink(name: appName, urlScheme: urlScheme))
            AppStorage.shared.saveApps(apps)
        } else {
            addApp(appName)
        }
        searchText = ""
    }
    
    func moveApp(from source: IndexSet, to destination: Int) {
        apps.move(fromOffsets: source, toOffset: destination)
        AppStorage.shared.saveApps(apps)
    }
    
    func deleteApp(at offsets: IndexSet) {
        apps.remove(atOffsets: offsets)
        AppStorage.shared.saveApps(apps)
    }
}
