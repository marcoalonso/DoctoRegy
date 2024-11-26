//
//  VisitsView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData

struct VisitsView: View {
    @Query var visits: [Visit]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var isAddingVisit = false

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredVisits) { visit in
                    NavigationLink(destination: EditVisitView(visit: visit)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person.crop.rectangle")
                                
                                Text("Dr. \(visit.doctorName)")
                                    .font(.headline)
                            }
                            HStack {
                                Image(systemName: "applepencil.and.scribble")
                                
                                Text("Diagnosis: \(visit.diagnosis)")
                                    .font(.subheadline)
                            }
                            HStack {
                                Image(systemName: "calendar.badge.exclamationmark")
                                
                                
                                Text("\(visit.date, formatter: Self.dateFormatter)")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteVisit)
            }
            .navigationTitle("Doctor Visits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: { isAddingVisit = true }) {
                    Label("Add Visit", systemImage: "plus")
                }
            }
            .searchable(text: $searchText)
            .sheet(isPresented: $isAddingVisit) {
                AddVisitView { newVisit in
                    addVisit(newVisit)
                }
            }
        }
    }

    var filteredVisits: [Visit] {
        visits
            .filter { visit in
                searchText.isEmpty || visit.doctorName.localizedCaseInsensitiveContains(searchText)
            }
            .sorted(by: { $0.date > $1.date }) // Ordenar por fecha descendente
    }

    func deleteVisit(at offsets: IndexSet) {
        offsets.forEach { index in
            let visit = visits[index]
            modelContext.delete(visit)
        }
    }

    func addVisit(_ newVisit: Visit) {
        do {
            modelContext.insert(newVisit)
            try modelContext.save()
        } catch {
            print("DEBUG: Failed to save visit: \(error.localizedDescription)")
        }
    }

    // MARK: - Date Formatter
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    VisitsView()
}
