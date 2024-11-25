//
//  AddReminderView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMedication: Medication? // Inicialmente puede ser nil
    @State private var dosage = ""
    @State private var timeInterval: TimeInterval = 8 * 3600 // Default: 8 hours
    @State private var durationDays = 5 // Default: 5 days

    var medications: [Medication]
    var onSave: (Reminder) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication")) {
                    Picker("Select Medication", selection: $selectedMedication) {
                        Text("Choose a Medication").tag(nil as Medication?) // Valor inicial
                        ForEach(medications) { medication in
                            Text(medication.name).tag(medication as Medication?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Dosage")) {
                    TextField("Dosage (e.g., 2.5 ml)", text: $dosage)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Frequency")) {
                    Stepper("Every \(Int(timeInterval / 3600)) hours", value: $timeInterval, in: 1 * 3600...12 * 3600, step: 3600)
                }

                Section(header: Text("Duration")) {
                    Stepper("\(durationDays) days", value: $durationDays, in: 1...30)
                }
            }
            .navigationTitle("Add Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveReminder()
                    }
                    .disabled(selectedMedication == nil || dosage.isEmpty)
                }
            }
        }
    }

    func saveReminder() {
        guard let medication = selectedMedication else { return }

        let repeatCount = Int((24 / (timeInterval / 3600)) * Double(durationDays))
        let newReminder = Reminder(
            medicationId: medication.id,
            dosage: dosage,
            timeInterval: timeInterval,
            repeatCount: repeatCount
        )
        onSave(newReminder)
        dismiss()
    }
}

#Preview {
    AddReminderView(medications: MockData.medications) { reminder in
        print("New Reminder: \(reminder)")
    }
}
