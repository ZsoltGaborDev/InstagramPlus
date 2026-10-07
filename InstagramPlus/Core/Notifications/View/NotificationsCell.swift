//
//  NotificationsCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI
import Kingfisher

struct NotificationsCell: View {
    let notification: IGNotification
    
    var body: some View {
        let username = Text(notification.user?.username ?? "")
            .font(.subheadline)
            .fontWeight(.semibold)
        
        let message = Text(" \(notification.type.notificationMessage)")
            .font(.subheadline)
        
//        let timestamp = Text(" \(notification.timestamp.timestampString())")
//            .foregroundStyle(Color(.gray))
//            .font(.subheadline)
//            .fontWeight(.semibold)
        
        HStack() {
            NavigationLink(value: notification.user) {
                CircularProfileImageView(user: notification.user, size:.xSmall)
            }
            
            //notification message
            HStack {
                Text("\(username) \(message) \("timestamp")")
            }
            
            Spacer()
            
            if notification.type == .follow {
                Button {
                    print("DEBUG: Handle follow...")
                } label: {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(.systemBlue))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

            } else {
                if let post = notification.post {
                    NavigationLink {
                        FeedCell(post: post)
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

#Preview {
    NotificationsCell(notification: DeveloperPreview.shared.notifications[0])
}
