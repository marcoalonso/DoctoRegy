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
    @State private var price = ""
    @State private var quantity = ""
    @State private var purchaseDate = Date() // Cambiado a fecha de compra

    var onSave: (Medication) -> Void

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Medication Name", text: $name)
                    
                    // Campo para precio obligatorio
                    TextField("$ Price (Required)", text: $price)
                        .keyboardType(.decimalPad)

                    TextField("Quantity (e.g., 100ml, 10 pills)", text: $quantity)

                    // Cambiado a fecha de compra
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                }
                
                Image("medicina")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 24)
                    .cornerRadius(18)
                
                .navigationTitle("Add Medication")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveMedication()
                        }
                        .disabled(name.isEmpty || quantity.isEmpty || !isPriceValid)
                    }
                }
            }
        }
    }

    // Validación de precio
    var isPriceValid: Bool {
        guard let priceValue = Double(price), priceValue > 0 else {
            return false
        }
        return true
    }

    func saveMedication() {
        let newMedication = Medication(
            name: name,
            price: Double(price) ?? 0.0,
            quantity: quantity,
            expirationDate: purchaseDate // Actualizado para usar la fecha de compra
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
