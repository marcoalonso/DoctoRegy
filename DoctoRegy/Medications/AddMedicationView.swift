//
//  AddMedicationView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import PhotosUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var mainSubstance: String? = nil
    @State private var quantity = ""
    @State private var expirationDate = Date()
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var medicationPhoto: UIImage? = nil

    var onSave: (Medication) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Medication Name", text: $name)
                TextField("Main Substance (Optional)", text: Binding(
                    get: { mainSubstance ?? "" },
                    set: { mainSubstance = $0.isEmpty ? nil : $0 }
                ))
                TextField("Quantity (e.g., 100ml, 10 pills)", text: $quantity)
                DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)

                Section(header: Text("Photo")) {
                    if let medicationPhoto {
                        Image(uiImage: medicationPhoto)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                    PhotosPicker("Select Photo", selection: $selectedPhoto, matching: .images)
                        .onChange(of: selectedPhoto) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    medicationPhoto = image
                                }
                            }
                        }
                }
            }
            .navigationTitle("Add Medication")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .disabled(name.isEmpty || quantity.isEmpty)
                }
            }
        }
    }

    func saveMedication() {
        let photoData = medicationPhoto?.jpegData(compressionQuality: 0.8)
        let newMedication = Medication(
            name: name,
            mainSubstance: mainSubstance,
            quantity: quantity,
            expirationDate: expirationDate,
            photo: photoData
        )
        onSave(newMedication)
        dismiss()
    }
}


#Preview {
    AddMedicationView { medication in
        print("Medication added: \(medication)")
    }
}
