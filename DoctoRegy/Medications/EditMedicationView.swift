//
//  EditMedicationView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData

struct EditMedicationView: View {
    @Bindable var medication: Medication
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Medication Details")) {
                TextField("Name", text: $medication.name)
                TextField("Price (Optional)", value: Binding(
                    get: { medication.price }, // Accede al valor de Double
                    set: { medication.price = $0 } // Guarda directamente el Double
                ), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
                TextField("Quantity (e.g., 100ml, 10 pills)", text: $medication.quantity)
                DatePicker("Expiration Date", selection: $medication.expirationDate, displayedComponents: .date)
            }
            Section {
                Button("Save Changes") {
                    saveMedication()
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Section {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete Medication")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Medication")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Are you sure you want to delete this medication?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteMedication()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func saveMedication() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }

    private func deleteMedication() {
        modelContext.delete(medication)
        dismiss()
    }
}

#Preview {
    EditMedicationView(medication: MockData.sampleMedication)
}
