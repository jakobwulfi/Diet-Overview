//
//  Diet_OverviewApp.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import SwiftUI
import FirebaseCore

@main
struct Diet_OverviewApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(SnackController())
        }
    }
}
