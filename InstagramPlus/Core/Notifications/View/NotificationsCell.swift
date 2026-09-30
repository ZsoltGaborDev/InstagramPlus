//
//  NotificationsCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 30/09/2026.
//

import SwiftUI

struct NotificationsCell: View {
    
    
    var body: some View {
        let username = Text("yuki")
            .font(.subheadline)
            .fontWeight(.semibold)
        
        let message = Text("liked your post ishiwh xihixsh xihsih xihsi soxshhf vrevve")
            .font(.subheadline)
        
        let timestamp = Text("3w")
            .foregroundStyle(Color(.gray))
            .fontWeight(.semibold)
        
        HStack {
            CircularProfileImageView(size:.xSmall)
            
            //notification message
            HStack {
                Text("\(username)\(message)\(timestamp)")
            }
            
            Spacer()
            
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipped()
                .background(Color(.gray))
                .foregroundStyle(Color(.white))
                .padding(.leading, 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationsCell()
}
