//
//  Snack.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import Foundation
import FirebaseFirestore

struct Snack: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let kcal: Double
    let date: Date
    let note: String
    let image: Data
}
