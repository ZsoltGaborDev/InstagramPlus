//
//  PostGridServiceProtocol.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 19/10/2026.
//


import Foundation

protocol PostGridServiceProtocol {
    func fetchPost() async throws -> [Post]
}