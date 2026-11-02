//
//  FollowrequestNotificationCell.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 02/11/2026.
//

import SwiftUI

struct FollowrequestNotificationCell: View {
    @Environment(FollowRequestViewModel.self) private var viewmodel
    
    var body: some View {
        NavigationLink {
            FollowRequestListView()
                .environment(viewmodel)
        } label: {
            VStack {
                HStack {
                    Text("Follow Requests")
                    
                    Spacer()
                    
                    if !viewmodel.requests.isEmpty {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                    }
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
                
                Divider()
            }
        }
    }
}

#Preview {
    FollowrequestNotificationCell()
}
