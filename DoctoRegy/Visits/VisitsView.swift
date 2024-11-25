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
                            Text(visit.doctorName)
                                .font(.headline)
                            Text(visit.diagnosis)
                                .font(.subheadline)
                            Text("\(visit.date, formatter: Self.dateFormatter)")
                                .font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteVisit)
            }
            .navigationTitle("Doctor Visits")
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
        visits.filter { visit in
            searchText.isEmpty || visit.doctorName.localizedCaseInsensitiveContains(searchText)
        }
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
