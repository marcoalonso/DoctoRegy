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
    @State private var amountSpent: Double = 0.0

    var onSave: (Visit) -> Void

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Doctor Name", text: $doctorName)
                TextField("Diagnosis", text: $diagnosis)
                TextField("Amount Spent", value: $amountSpent, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Visit")
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
                    .disabled(doctorName.isEmpty || diagnosis.isEmpty)
                }
            }
        }
    }

    func saveVisit() {
        let newVisit = Visit(
            date: date,
            doctorName: doctorName,
            diagnosis: diagnosis,
            amountSpent: amountSpent
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
