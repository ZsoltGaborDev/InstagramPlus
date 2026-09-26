//
//  ImageUploader.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 25/09/2026.
//

import UIKit
import Cloudinary

enum ImageUploadFolder: String {
    case profile = "profile_images"
    case post = "post_images"
}

enum ImageUploaderError: Error {
    case invalidImageData
    case missingSecureURL
    case uploadFailed(String)
}

struct ImageUploader {

    private static let cloudinary: CLDCloudinary = {
        let config = CLDConfiguration(cloudName: CloudinaryConfig.cloudName, secure: true)
        return CLDCloudinary(configuration: config)
    }()

    static func uploadProfileImage(_ image: UIImage) async throws -> String {
        try await upload(image, folder: .profile)
    }

    static func uploadPostImage(_ image: UIImage) async throws -> String {
        try await upload(image, folder: .post)
    }

    private static func upload(_ image: UIImage, folder: ImageUploadFolder) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw ImageUploaderError.invalidImageData
        }

        let params = CLDUploadRequestParams()
            .setFolder(folder.rawValue)

        return try await withCheckedThrowingContinuation { continuation in
            cloudinary.createUploader()
                .upload(
                    data: data,
                    uploadPreset: CloudinaryConfig.uploadPreset,
                    params: params
                )
                .response { result, error in
                    if let error {
                        continuation.resume(throwing: ImageUploaderError.uploadFailed(error.localizedDescription))
                        return
                    }
                    guard let secureUrl = result?.secureUrl else {
                        continuation.resume(throwing: ImageUploaderError.missingSecureURL)
                        return
                    }
                    continuation.resume(returning: secureUrl)
                }
        }
    }
}
