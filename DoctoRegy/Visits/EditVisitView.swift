//
//  EditVisitView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData

struct EditVisitView: View {
    @Bindable var visit: Visit
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Visit Details")) {
                DatePicker("Date Visit", selection: $visit.date, displayedComponents: .date)
                TextField("Doctor Name", text: $visit.doctorName)
                TextField("Diagnosis", text: $visit.diagnosis)
                TextField("Amount Spent", value: $visit.amountSpent, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Image("visit")
                .resizable()
                .scaledToFit()
                .cornerRadius(18)
                .padding()
            
            HStack {
                Button {
                    saveVisit()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.green)
                        .cornerRadius(22) // Botón con forma circular
                        .padding(.horizontal)
                }

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .cornerRadius(22) // Botón con forma circular
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            
        }
        .navigationTitle("Edit Visit")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Are you sure you want to delete this visit?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteVisit()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func saveVisit() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save visit: \(error)")
        }
    }

    private func deleteVisit() {
        modelContext.delete(visit)
        dismiss()
    }
}

#Preview {
    EditVisitView(visit: MockData.sampleVisit)
}
