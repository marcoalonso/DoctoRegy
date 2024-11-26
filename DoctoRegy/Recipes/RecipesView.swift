//
//  RecipesView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct RecipesView: View {
    @Query var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingRecipe = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var newRecipePhoto: UIImage? = nil

    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(recipes) { recipe in
                        if let image = UIImage(data: recipe.photo) { // Convertimos directamente a UIImage
                            NavigationLink(destination: FullScreenPhotoView(image: image)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            }
                        }
                    }
                }
                .padding()
                .toolbar {
                    Button(action: { isAddingRecipe = true }) {
                        Label("Add Recipe", systemImage: "camera")
                    }
                }
            }
            .navigationTitle("Recipes")
            .sheet(isPresented: $isAddingRecipe) {
                addRecipeSheet
            }
        }
    }

    @ViewBuilder
    private var addRecipeSheet: some View {
        PhotosPicker("Select Recipe Photo", selection: $selectedPhoto, matching: .images)
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        newRecipePhoto = image
                        saveRecipePhoto()
                    }
                }
            }
    }

    func saveRecipePhoto() {
        guard let imageData = newRecipePhoto?.jpegData(compressionQuality: 0.8) else { return }
        let newRecipe = Recipe(photo: imageData)
        modelContext.insert(newRecipe)
        newRecipePhoto = nil
    }
}

#Preview {
    RecipesView()
}
