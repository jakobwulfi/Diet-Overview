//
//  ContentView.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(SnackController.self) private var snackController
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Kalorier spist denne uge")
                    .font(.title)
                Text(String(format: "%.2f", snackController.getWeeklyKCAL()) + " kcal")
                    .font(.title3)
            }
            .padding()
            VStack {
                Text("Kalorier spist i dag")
                    .font(.title)
                Text(String(format: "%.2f", snackController.getDailyKCAL()) + " kcal")
                    .font(.title3)
            }
            List {
                if (snackController.snacks.isEmpty) {
                    ProgressView()
                } else {
                    ForEach(snackController.getWeeklySnacks()) { snack in
                        NavigationLink(destination: DetailView(snack: snack)) {
                            HStack {
                                Text(snack.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(String(format: "%.2f", snack.kcal)) kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(snack.date.formatted())
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: ListView()) {
                        Text("Oversigt")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: AddSnackView()) {
                        Text("Tilføj Snacking")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ContentView().environment(SnackController())
}
