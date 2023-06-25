//
//  FlashcardManager.swift
//  language learning app (iOS)
//
//  Created by Larissa Troper on 2023-06-24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Flashcard: Codable {
    let id: String
    let term: String?
    let answer: String?
    let dateCreated: Date?
    let isActive: Bool?
    let lastDateTested: Date?

    init(id: String,
    term: String? = nil,
    answer: String? = nil,
    dateCreated: Date? = nil,
    isActive: Bool? = true,
    lastDateTested: Date? = nil
    ) {
        self.id = id
        self.term = term
        self.answer = answer
        self.dateCreated = dateCreated
        self.isActive = isActive
        self.lastDateTested = lastDateTested
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "flashcard_id"
        case term = "term"
        case answer = "answer"
        case dateCreated = "date_created"
        case isActive = "is_active"
        case lastDateTested = "last_date_tested"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.term = try container.decodeIfPresent(String.self, forKey: .term)
        self.answer = try container.decodeIfPresent(String.self, forKey: .answer)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        self.lastDateTested = try container.decodeIfPresent(Date.self, forKey: .lastDateTested)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.term, forKey: .term)
        try container.encodeIfPresent(self.answer, forKey: .answer)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isActive, forKey: .isActive)
        try container.encodeIfPresent(self.lastDateTested, forKey: .lastDateTested)
    }

}

final class FlashcardManager {
    
    static let shared = FlashcardManager()
    private init() { }
    
    private let flashcardCollection = Firestore.firestore().collection("flashcards")
    
    
}
