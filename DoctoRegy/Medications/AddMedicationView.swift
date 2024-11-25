//
//  AddMedicationView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var mainSubstance: String? = nil
    @State private var quantity = ""
    @State private var expirationDate = Date()

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
            }
            .navigationTitle("Add Medication")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
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
        let newMedication = Medication(
            name: name,
            mainSubstance: mainSubstance,
            quantity: quantity,
            expirationDate: expirationDate
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
