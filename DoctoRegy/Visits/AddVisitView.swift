//
//  AddVisitView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct AddVisitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var doctorName = ""
    @State private var diagnosis = ""
    @State private var amountSpent: String = "" // Cambiamos a String para manejar el placeholder

    var onSave: (Visit) -> Void

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Doctor Name", text: $doctorName)
                    TextField("Diagnosis", text: $diagnosis)
                    
                    // TextField con un placeholder para "Amount Spent"
                    TextField("$ Amount Spent", text: $amountSpent)
                        .keyboardType(.decimalPad)
                }
                .navigationTitle("Add Visit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveVisit()
                        }
                        .disabled(doctorName.isEmpty || diagnosis.isEmpty || !isAmountValid)
                    }
                }
                Image("pediatra")
                    .resizable()
                    .cornerRadius(18)
                    .padding(.horizontal, 24)
            }
        }
    }

    var isAmountValid: Bool {
        // Validar que amountSpent sea un número decimal positivo
        if let value = Double(amountSpent), value >= 0 {
            return true
        }
        return false
    }

    func saveVisit() {
        let newVisit = Visit(
            date: date,
            doctorName: doctorName,
            diagnosis: diagnosis,
            amountSpent: Double(amountSpent) ?? 0.0 // Convierte a Double al guardar
        )
        onSave(newVisit)
        dismiss()
    }
}

#Preview {
    AddVisitView { visit in
        print("New Visit Saved: \(visit)")
    }
}
