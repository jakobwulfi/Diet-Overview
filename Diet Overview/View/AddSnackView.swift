//
//  AddSnackView.swift
//  Diet Overview
//
//  Created by dmu mac 31 on 23/12/2024.
//

import SwiftUI
import PhotosUI
struct AddSnackView: View {
    @Environment(SnackController.self) private var snackController
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var kcal: String = ""
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    
    var snackImage: Image {
        guard let data = selectedImageData,
              let image = UIImage(data: data) else {
            return Image(systemName: "birthday.cake.fill")
        }
        return Image(uiImage: image)
    }
    
    var body: some View {
        Form {
            VStack {
                snackImage
                    .resizable()
                    .frame(width: 150, height: 150)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Photo", systemImage: "photo")
                }
            }
            Group {
                TextField("Enter navn", text: $name)
                
                TextField("Enter kcal", text: $kcal)
                    .keyboardType(.decimalPad) // Ensures numeric input with decimal
                
                TextField("Enter note", text: $note)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button("Tilføj Snacking") {
                if name.isEmpty || Double(kcal) == nil {
                    showAlert = true
                } else {
                    let newSnack = Snack(
                        name: name,
                        kcal: Double(kcal)!,
                        date: Date.now,
                        note: note,
                        image: selectedImageData ?? UIImage(systemName: "birthday.cake.fill")!.pngData()!
                    )
                    snackController.add(snack: newSnack)
                    showSuccessAlert = true
                }
            }
            .fontWeight(.bold)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Du skal skrive et navn for din snak og et tal for kcal.")
            }
            .alert("Snacking Tilføjet", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Din Snacking er tilføjet.")
            }
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task(priority: .medium) {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    let image = UIImage(data: data)
                    let compression = 0.5
                    let compressedImage = image?.jpegData(compressionQuality: compression)
                    
                    selectedImageData = compressedImage
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddSnackView().environment(SnackController())
}
