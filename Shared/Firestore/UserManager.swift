//
//  UserManager.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let languages: [String]?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.languages = nil
    }
    
    init(userId: String,
    email: String? = nil,
    photoUrl: String? = nil,
    dateCreated: Date? = nil,
    isPremium: Bool? = nil,
    languages: [String]? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.languages = languages
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case languages = "languages"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.languages, forKey: .languages)
    }

}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
//    private func userFlashcardCollectionByLanguage(userId: String, language:String) -> CollectionReference {
//        userDocument(userId: userId).collection("\(language)_flashcard_collection")
//    }
    
//    private func userFlashcardDocumentByLanguageCollection(userId: String, language:String, flashcardCollectionId: String) -> DocumentReference {
//        userFlashcardCollectionByLanguage(userId: userId, language:language).document(flashcardCollectionId)
//    }
//
    private func userFlashcardCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("flashcards")
    }
    
    private func userFlashcardDocument(userId: String, flashcardId: String, language: String) -> DocumentReference {
        userFlashcardCollection(userId: userId).document(flashcardId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try  userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserLanguage(userId: String, language: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.languages.rawValue : FieldValue.arrayUnion([language])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserLanguage(userId: String, language: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.languages.rawValue : FieldValue.arrayRemove([language])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFlashcardCollection(userId: String, language:String) async throws {
        let document = userFlashcardCollection(userId: userId).document("\(language)_flashcards")
        
        do {
            let documentSnapshot = try await document.getDocument()

            if !documentSnapshot.exists {
                let data: [String: Any] = [
                    "language": language,
                    "date_created": Timestamp()
                ]
                try await document.setData(data, merge: false)
            }
        } catch {
            print("Error retrieving or creating document: \(error)")
        }
    }
    
    func getFlashcardCollections(userId: String) async throws {
        let collection = userFlashcardCollection(userId: userId)
        
        do {
            let querySnapshot = try await collection.getDocuments()
            for document in querySnapshot.documents {
                print(document.data())
                print(document.documentID)
            }
        } catch {
            throw error
        }
    }
    
    
    func addUserFlashcard(userId: String, flashcardId: String, term: String, answer: String, isActive: Bool, status: Bool) async throws {
        let document = userFlashcardCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            "id": documentId,
            "flashcard_id": flashcardId,
            "term": term,
            "answer": answer,
            "is_active": isActive,
            "date_created": Timestamp(),
            "last_test": [nil, status]
        ]
        
        try await document.setData(data, merge: false)
    }
    
//    func removeUserFlashcard(userId: String, flashcardId: String) async throws {
//        try await userFlashcardDocument(userId: userId, flashcardId: flashcardId).delete()
//    }
    
}
