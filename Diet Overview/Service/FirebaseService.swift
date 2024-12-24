//
//  FirebaseService.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import Foundation
import FirebaseFirestore

struct FirebaseService {
    private let dbCollection = Firestore.firestore().collection("snacks")
    private var listener: ListenerRegistration?
    
    mutating func setUpListener(callback: @escaping ([Snack]) -> Void) {
        listener = dbCollection.order(by: "date", descending: false).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            let snacks = documents.compactMap{ queryDocumentSnapshot -> Snack? in
                return try? queryDocumentSnapshot.data(as: Snack.self)
            }
            callback(snacks)
        }
    }
    
    func getSortedSnacks() async -> [Snack] {
        do {
            let query = try await dbCollection.getDocuments()
            let sortedSnacks = query.documents.compactMap { queryDocumentSnapshot -> Snack? in
                return try? queryDocumentSnapshot.data(as: Snack.self)
            }
            return sortedSnacks
        } catch {
            print("Error getting documents: \(error)")
            return []  // Return an empty array in case of an error
            }
    }
    
    mutating func tearDownListener() {
        listener?.remove()
        listener = nil
    }
    
    func addSnack(snack: Snack) {
        do {
            let _ = try dbCollection.addDocument(from: snack.self)
        } catch {
            print(error)
        }
    }
    
    func deleteSnack(snack: Snack) {
        guard let documentID = snack.id else { return }
        dbCollection.document(documentID).delete() { error in
            if let error {
                print(error)
            }
        }
    }
    
}
