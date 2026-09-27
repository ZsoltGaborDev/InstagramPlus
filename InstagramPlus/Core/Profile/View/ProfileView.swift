//
//  ProfileView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 09/09/2026.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    var body: some View {
        ScrollView {
            ProfileHeaderView(user: user)
            PostGridView(user: user)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER[3])
}
