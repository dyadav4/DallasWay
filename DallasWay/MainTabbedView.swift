//
//  ContentView.swift
//  Dallaspere
//
//  Created by Dharamvir Yadav on 8/23/24.
//

import SwiftUI

struct MainTabbedView: View {
    @State private var selectedTab: Tab = .explore
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Step 3: Iterate over Tab enum cases to create tabs
            ForEach(Tab.allCases) { tab in
                tabView(for: tab)
                    .tabItem {
                        Image(systemName: tab.iconName)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
        .accentColor(.blue)
    }
    
    @ViewBuilder
    private func tabView(for tab: Tab) -> some View {
        switch tab {
        case .explore:
            NavigationStack {
                ExploreView()
            }
        case .events:
            Text("Events View")
        case .news:
            Text("Profile View")
        case .jobs:
            Text("Jobs View")
        }
    }
}

enum Tab: String, CaseIterable, Identifiable {
    case explore, events, news, jobs
    
    // Conform to Identifiable
    var id: String { self.rawValue }
    
    // Properties for the icon name and title
    var iconName: String {
        switch self {
        case .explore: return "map"
        case .events: return "calendar"
        case .news: return "doc.text"
        case .jobs: return "briefcase"
        }
    }
    
    var title: String {
        self.rawValue.capitalized
    }
}

#Preview {
    MainTabbedView()
}
