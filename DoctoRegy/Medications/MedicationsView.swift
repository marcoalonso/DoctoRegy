//
//  MedicationsView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData

struct MedicationsView: View {
    @Query var medications: [Medication]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var isAddingMedication = false

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredMedications) { medication in
                    NavigationLink(destination: EditMedicationView(medication: medication)) {
                        VStack(alignment: .leading) {
                            Text(medication.name)
                                .font(.headline)
                            if let substance = medication.mainSubstance {
                                Text(substance)
                                    .font(.subheadline)
                            }
                            Text("\(medication.quantity)")
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteMedication)
            }
            .navigationTitle("Medications")
            .toolbar {
                Button(action: { isAddingMedication = true }) {
                    Label("Add Medication", systemImage: "plus")
                }
            }
            .searchable(text: $searchText)
            .sheet(isPresented: $isAddingMedication) {
                AddMedicationView { newMedication in
                    addMedication(newMedication)
                }
            }
        }
    }

    var filteredMedications: [Medication] {
        medications.filter { medication in
            searchText.isEmpty || medication.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { index in
            let medication = medications[index]
            modelContext.delete(medication)
        }
    }

    func addMedication(_ newMedication: Medication) {
        do {
            modelContext.insert(newMedication)
            try modelContext.save()
        } catch {
            print("Debug: error saving medication: \(error.localizedDescription)")
        }
    }
}


#Preview {
    MedicationsView()
}