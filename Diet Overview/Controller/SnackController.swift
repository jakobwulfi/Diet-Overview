//
//  SnackController.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import SwiftUI

@Observable
class SnackController {
    var snacks = [Snack]()
    
    @ObservationIgnored
    private var firebaseService = FirebaseService()
    
    init() {
        firebaseService.setUpListener { fetchedSnacks in
            self.snacks = fetchedSnacks
        }
    }
    
    func getDailyKCAL() -> Double {
        print("Array længde: \(snacks.count)")
        let dailyKcal = snacks.filter {
            print("Snack date: \($0.date)")
            print("Bobby")
            return Calendar.current.isDateInToday($0.date)
        }.reduce(0.0) { total, snack in
            print("Adding kcal: \(snack.kcal)")
            return total + snack.kcal // Sum up the kcal of today's snacks
        }
        return dailyKcal
    }
    
    func getWeeklyKCAL() -> Double {
        let today = Date()
        guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0.0 // Return 0 if startOfWeek calculation fails
        }
        
        let totalKcalThisWeek = snacks.filter { snack in
            snack.date >= startOfWeek && snack.date <= today
        }.reduce(0.0) { total, snack in
            total + snack.kcal
        }
        return totalKcalThisWeek
    }
    
    func getWeeklySnacks() -> [Snack] {
        let today = Date()
        guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return [] 
        }
        
        return snacks.filter { snack in
            snack.date >= startOfWeek && snack.date <= today
        }
    }
    
    func add(snack: Snack) {
        firebaseService.addSnack(snack: snack)
    }

    func delete(snack: Snack) {
        firebaseService.deleteSnack(snack: snack)
    }
    
    func update(snack: Snack) {
        firebaseService.addSnack(snack: snack)
    }
}
