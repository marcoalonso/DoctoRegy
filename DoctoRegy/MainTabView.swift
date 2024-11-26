//
//  ContentView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            VisitsView()
                .tabItem {
                    Label("Visits", systemImage: "stethoscope")
                }
            MedicationsView()
                .tabItem {
                    Label("Medications", systemImage: "pills")
                }
            RemindersView()
                .tabItem {
                    Label("Reminders", systemImage: "bell")
                }
            ExpensesView()
                .tabItem {
                    Label("Expenses", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
