//
//  SearchView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct SearchView: View {
    
    init(config: UserListConfiguration) {}
    
    var body: some View {
        NavigationStack {
            UserListView(config: .explore)
        }
    }
}

#Preview {
    SearchView(config: .explore)
}
