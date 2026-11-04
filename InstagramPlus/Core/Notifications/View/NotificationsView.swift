//
//  NotificationsView.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(UserManager.self) private var userManager
    @State private var viewModel: IGNotificationsViewModel
    @State private var followRequestViewModel: FollowRequestViewModel
    
    init() {
        let userService = UserService()
        
        _viewModel = State(wrappedValue: IGNotificationsViewModel(
            service: IGNotificationFetchingService(),
            userService: userService, followService: FollowService()))
        
        _followRequestViewModel = State(
            wrappedValue: FollowRequestViewModel(
                followRequestService: FollowRequestService(),
                userService: userService,
                notificationManager: IGNotificationsManager(
                    service: IGNotificationManagementService()
                )
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isPrivateProfile {
                    FollowrequestNotificationCell()
                        .environment(followRequestViewModel)
                }
                switch viewModel.loadingState {
                case .empty:
                    IGContentUnavailableView(
                        "Nothing to see here",
                        systemImage: "bell.circle",
                        description: "Your notifications will appear here when users interact with you."
                    )
                    .containerRelativeFrame(.vertical)
                case .error:
                    Text("An error occurred..")
                case .loading:
                    ProgressView()
                        .containerRelativeFrame(.vertical)
                case .complete:
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationsCell(notification: notification)
                                .environment(viewModel)
                                .padding(.top)
                        }
                    }
                }
            }
            .task {
                await fetchFollowReqests()
            }
            .refreshable {
                await viewModel.refreshNotifications()
            }
//            .navigationDestination(for: Post.self, destination: { post in
//                FeedCell(post: post)
//            })
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension NotificationsView {
    private var isPrivateProfile: Bool {
        return userManager.currentUser?.isPrivate ?? false
    }
    
    func fetchFollowReqests() async {
        guard isPrivateProfile else { return }
        
        await followRequestViewModel.fetchRequest()
    }
}

#Preview {
    NotificationsView()
}
