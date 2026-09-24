//
//  CurrentUserProfile.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 10/09/2026.
//

import SwiftUI

struct CurrentUserProfile: View {
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollView {
            //header
            VStack(spacing: 10) {
                // pic and stats
                HStack {
                    Image("instagramPlus1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    HStack{
                        UserStatView(value: 43, title: "Posts")
                        
                        UserStatView(value: 112, title: "Followers")
                        
                        UserStatView(value: 92, title: "Following")
                    }
                }
                .padding(.horizontal)
                
                //name and bio
                VStack(alignment: .leading, spacing: 4) {
                    Text("Chadwick Bozeman")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("Wakanda Forever")
                        .font(.footnote)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                //action button
                Button {
                    
                } label: {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                
                Divider()
            }
            
            //post grid view
            LazyVGrid(columns: gridItems, spacing: 1) {
                ForEach(0 ... 15, id: \.self) { index in
                    Image("instagramPlus6")
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfile()
}
