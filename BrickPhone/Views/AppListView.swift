//
//  AppListView.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/12/24.
//

import SwiftUI
import WidgetKit

struct AppListView: View {
    @State private var apps: [AppLink] = []
    @State private var searchText = ""
    @State private var isShowingSearch = false
    @State private var showMaxAppsAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#242424")
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(apps, id: \.name) { app in
                            Text(app.name)
                                .foregroundColor(.white)
                                .listRowBackground(Color(hex: "#242424"))
                        }
                        .onDelete(perform: deleteItems)
                        .onMove(perform: moveItems)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    
                    WallpaperPrompt()
                        .padding()
                        
                    Text("If an app is not found, create a shortcut that opens the app and name the shortcut the same name as the app. ")
                        .foregroundColor(.gray)
                        .padding()
                        .padding(.bottom, 100)

                    Button(action: {
                        if apps.count >= 6 {
                            showMaxAppsAlert = true
                        } else {
                            isShowingSearch = true
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("BrickPhone")
            .toolbarBackground(Color(hex: "#242424"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .foregroundColor(.white)
            .sheet(isPresented: $isShowingSearch) {
                SearchView(
                    searchText: $searchText,
                    isShowingSearch: $isShowingSearch,
                    existingApps: apps,
                    onAppSelected: { appName in
                        addApp(appName)
                    }
                )
            }
            .alert("Maximum Apps Reached", isPresented: $showMaxAppsAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You can't add more than 6 apps.")
            }
        }
        .onAppear {
            loadApps()
        }
    }
    
    private func loadApps() {
        if let data = UserDefaults(suiteName: Constants.appGroupIdentifier)?.data(forKey: Constants.widgetAppsKey),
           let loadedApps = try? JSONDecoder().decode([AppLink].self, from: data) {
            apps = loadedApps
        }
    }
    
    private func addApp(_ name: String) {
        guard apps.count < 6 else {
            showMaxAppsAlert = true
            return
        }
        
        let urlScheme = AppDatabase.knownApps[name] ??
            AppDatabase.generateShortcutScheme(for: name)
        let newApp = AppLink(name: name, urlScheme: urlScheme)
        apps.append(newApp)
        saveApps()
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        apps.move(fromOffsets: source, toOffset: destination)
        saveApps()
    }
    
    private func deleteItems(at offsets: IndexSet) {
        apps.remove(atOffsets: offsets)
        saveApps()
    }
    
    private func saveApps() {
        if let encoded = try? JSONEncoder().encode(apps) {
            UserDefaults(suiteName: Constants.appGroupIdentifier)?
                .set(encoded, forKey: Constants.widgetAppsKey)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isShowingSearch: Bool
    let existingApps: [AppLink]
    let onAppSelected: (String) -> Void
    
    private var filteredSuggestions: [String] {
        let knownApps = AppDatabase.knownApps.keys
            .filter { appName in
                !existingApps.contains(where: { $0.name == appName })
            }
            .filter {
                searchText.isEmpty || $0.lowercased().contains(searchText.lowercased())
            }
            .sorted()
        
        // Only add the custom option if there's search text and no exact match
        if !searchText.isEmpty && !knownApps.contains(searchText) &&
           !existingApps.contains(where: { $0.name == searchText }) {
            return knownApps + ["\(searchText) not found. Add anyway?"]
        }
        
        return knownApps
    }
    
    var body: some View {
        NavigationStack {
            List(filteredSuggestions, id: \.self) { suggestion in
                Button(action: {
                    if suggestion.hasSuffix("not found. Add anyway?") {
                        let appName = suggestion.replacingOccurrences(
                            of: " not found. Add anyway?",
                            with: ""
                        )
                        onAppSelected(appName)
                    } else {
                        onAppSelected(suggestion)
                    }
                    isShowingSearch = false
                }) {
                    Text(suggestion)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("Add App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isShowingSearch = false
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer)
        }
    }
}

// Color extension for hex support

