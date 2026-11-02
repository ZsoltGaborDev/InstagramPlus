//
//  UserListView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/09/2026.
//

import SwiftUI

struct UserListView: View {
    
    @State var viewModel = UserListViewModel(service: UserListService(userService: UserService()))
    @State private var searchText = ""
    
    private let config: UserListConfiguration
    
    init(config: UserListConfiguration) {
        self.config = config
    }
    
    var body: some View {
        ScrollView {
            switch viewModel.loadingState {
            case .empty:
                IGContentUnavailableView("Nothing to show here.", systemImage: "paperplane.circle", description: "Users will appear here who likes this post.")
                    .containerRelativeFrame(.vertical)
            case .error:
                Text("Error occurred ..")
            case .loading:
                ProgressView()
                    .containerRelativeFrame(.vertical)
            case .complete:
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            HStack {
                                CircularProfileImageView(user: user, size: .xSmall)
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .fontWeight(.semibold)
                                    
                                    if let fullname = user.fullname {
                                        Text(fullname)
                                    }
                                }
                                .font(.footnote)
                                .foregroundStyle(.primaryText)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search...")
            }
        }
        .navigationDestination(for: User.self, destination: { user in
            ProfileView(user: user)
        })
        .navigationTitle(config.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchUsers(forConfig: config)
        }
    }
}

#Preview {
    UserListView(config: .explore)
}
