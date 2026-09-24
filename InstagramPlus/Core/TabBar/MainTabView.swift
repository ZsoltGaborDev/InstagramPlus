//
//  TabBarView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            Text("Upload Post")
                .tabItem {
                    Image(systemName: "plus.square")
                }
            Text("Notifications")
                .tabItem {
                    Image(systemName: "heart")
                }
            CurrentProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    MainTabView()
}
