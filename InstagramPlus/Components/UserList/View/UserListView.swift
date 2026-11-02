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
    
    @State private var activeScrollId: String?
    @State private var paginating = false
    
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
                        .id(user.id)
                    }
                    if paginating {
                        ProgressView()
                    }
                }
                .scrollTargetLayout()
                .padding(.top, 8)
                .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search...")
            }
        }
        .scrollPosition(id: $activeScrollId, anchor: .bottom)
        .onChange(of: activeScrollId, { oldValue, newValue in
            loadMoreDataIfNecessary(newValue)
        })
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

private extension UserListView {
    func loadMoreDataIfNecessary(_ activeScrollId: String?) {
        guard activeScrollId == viewModel.users.last?.id else { return }
        
        Task {
            paginating = true
            await viewModel.fetchUsers(forConfig: config)
            paginating = false
        }
    }
}

#Preview {
    UserListView(config: .explore)
}
