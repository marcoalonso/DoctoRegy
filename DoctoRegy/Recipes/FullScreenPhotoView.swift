//
//  FullScreenPhotoView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct FullScreenPhotoView: View {
    var image: UIImage

    var body: some View {
        NavigationView {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationTitle("Recipe Photo")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FullScreenPhotoView(image: UIImage(named: "recipe")!)
}
