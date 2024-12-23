//
//  DatabaseController.swift
//  Backyard Birdies
//
//  Created by dmu mac 31 on 09/12/2024.
//

import Foundation
import FirebaseFirestore

struct FirebaseService {
    private let dbCollection = Firestore.firestore().collection("birdspots")
    private var listener: ListenerRegistration?
    
    mutating func setUpListener(callback: @escaping ([Birdspot]) -> Void) {
        listener = dbCollection.order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            let birdspots = documents.compactMap{ queryDocumentSnapshot -> Birdspot? in
                return try? queryDocumentSnapshot.data(as: Birdspot.self)
            }
            callback(birdspots)
        }
    }
    
    func getSortedBirdspots() async -> [Birdspot] {
        do {
            let query = try await dbCollection.getDocuments()
            let sortedBirdspots = query.documents.compactMap { queryDocumentSnapshot -> Birdspot? in
                return try? queryDocumentSnapshot.data(as: Birdspot.self)
            }
            return sortedBirdspots
        } catch {
            print("Error getting documents: \(error)")
            return []  // Return an empty array in case of an error
            }
    }
    
    mutating func tearDownListener() {
        listener?.remove()
        listener = nil
    }
    
    func addBirdspot(birdspot: Birdspot) {
        do {
            let _ = try dbCollection.addDocument(from: birdspot.self)
        } catch {
            print(error)
        }
    }
    
    func deleteBirdspot(birdspot: Birdspot) {
        guard let documentID = birdspot.id else { return }
        dbCollection.document(documentID).delete() { error in
            if let error {
                print(error)
            }
        }
    }
}
