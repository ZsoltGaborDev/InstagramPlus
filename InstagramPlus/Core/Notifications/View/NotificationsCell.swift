//
//  NotificationsCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI
import Kingfisher

struct NotificationsCell: View {
    @Environment(IGNotificationsViewModel.self) var viewModel
    
    private let notification: IGNotification
    
    init(notification: IGNotification) {
        self.notification = notification
    }
    
    var body: some View {
        let username = Text(notification.user?.username ?? "")
            .font(.subheadline)
            .fontWeight(.semibold)
        
        let message = Text(" \(notification.type.notificationMessage)")
            .font(.subheadline)
        
        let timestamp = Text(" \(notification.timestamp.timestampString())")
            .foregroundStyle(Color(.gray))
            .font(.subheadline)
            .fontWeight(.semibold)
        
        HStack() {
            NavigationLink(value: notification.user) {
                CircularProfileImageView(user: notification.user, size:.xSmall)
            }
            
            //notification message
            HStack {
                Text("\(username) \(message) \(timestamp)")
            }
            
            Spacer()
            
            if notification.type == .follow {
                Button {
                    followedButtonTapped()
                } label: {
                    Text(buttonTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 100, height: 34)
                        .background(buttonBackgroundColor)
                        .foregroundStyle(buttonForegroundColor)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(buttonBorderColor, lineWidth: 1)
                        )
                }

            } else {
                if let _ = notification.post {
                    NavigationLink {
                        // TODO: FeedCell(post: post)
                    } label: {
                        KFImage(URL(string: notification.post?.imageUrl ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipped()
                            .background(Color(.gray))
                            .foregroundStyle(Color(.white))
                            .padding(.leading, 2)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

private extension NotificationsCell {
    var notificationIndex: Int? {
        return viewModel.notifications.firstIndex(where: {$0.id == notification.id})
    }
    
    private func followedButtonTapped() {
        guard let relationState = notification.user?.userRelationState else {return}
        
        switch relationState {
        case .notFollowed:
            viewModel.follow(for: notification, index: notificationIndex)
        case .followed:
            viewModel.unfollow(for: notification, index: notificationIndex)
        case .requestedToFollow:
            print("DEBUG: Remove follow request here..")
        default:
            break
        }
    }
}

//TODO: make reusable component
extension NotificationsCell {
    
    private var buttonTitle: String {
        let relationState = notification.user?.userRelationState ?? .unknown
        
        switch relationState {
        case .unknown:
            return "Loading"
        case .notFollowed:
            return "Follow"
        case .followed:
            return "Unfollow"
        case .requestedToFollow:
            return "Requested"
        case .blocked:
            return "Blocked"
        default:
            return "Loading"
        }
    }
    
    private var buttonBackgroundColor: Color {
        guard let relationState = notification.user?.userRelationState else { return .secondaryButtonBackground}
        switch relationState {
        case .followed:
            return .primaryButtonBackground
        default:
            return .secondaryButtonBackground
        }
    }
    
    private var buttonForegroundColor: Color {
        guard let relationState = notification.user?.userRelationState else { return .secondaryText }
        
        switch relationState {
        case .followed:
            return .primaryText
        default:
            return .secondaryText
        }
    }
    
    private var buttonBorderColor: Color {
        guard let relationState = notification.user?.userRelationState else { return .clear }
        switch relationState {
        case .followed:
            return .secondaryButtonBackground
        default:
            return .clear
        }
    }
}

#Preview {
    NotificationsCell(notification: DeveloperPreview.shared.notifications[0])
}
