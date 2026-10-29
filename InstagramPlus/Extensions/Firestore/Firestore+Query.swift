//
//  Firestore+Query.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 29/10/2026.
//

import FirebaseFirestore

extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }
}
