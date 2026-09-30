//
//  NotificationsCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI

struct NotificationsCell: View {
    let notification: IGNotification
    
    var body: some View {
        let username = Text("yuki")
            .font(.subheadline)
            .fontWeight(.semibold)
        
        let message = Text(" \(notification.type.notificationMessage)")
            .font(.subheadline)
        
        let timestamp = Text("3w")
            .foregroundStyle(Color(.gray))
            .fontWeight(.semibold)
        
        HStack() {
            CircularProfileImageView(size:.xSmall)
            
            //notification message
            HStack {
                Text("\(username) \(message) \(timestamp)")
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
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
                    .background(Color(.gray))
                    .foregroundStyle(Color(.white))
                    .padding(.leading, 2)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationsCell(notification: DeveloperPreview.shared.notifications[0])
}
