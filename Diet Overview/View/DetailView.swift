//
//  DetailView.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import SwiftUI

struct DetailView: View {
    let snack: Snack
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let previewSnack = Snack(name: "KitKat", kcal: 300, date: Date.now, note: "Test", image: UIImage(systemName: "birthday.cake.fill")!.pngData()!)
    DetailView(snack: previewSnack).environment(SnackController())
}
