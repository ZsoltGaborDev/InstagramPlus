//
//  SearchView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct SearchView: View {
    
    init(config: UserListConfig) {}
    
    var body: some View {
        NavigationStack {
            UserListView(config: .explore)
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchView(config: .explore)
}
