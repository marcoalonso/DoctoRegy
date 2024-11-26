//
//  ExpensesView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftData
import SwiftUI
import Charts

struct ExpensesView: View {
    @Query var visits: [Visit]
    @Query var medications: [Medication]
    @State private var selectedFilter: TimeFilter = .month

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Filter by Time")) {
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(TimeFilter.allCases, id: \.self) { filter in
                                Text(filter.rawValue.capitalized).tag(filter)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                // Gráfico circular de gastos
                pieChart
                    .frame(height: 300)
                    .padding()

                Spacer()
            }
            .navigationTitle("Expenses")
        }
    }

    // Gráfico circular
    private var pieChart: some View {
        Chart {
            ForEach(categorySummaries, id: \.category) { summary in
                BarMark(
                    x: .value("Category", summary.category.rawValue.capitalized),
                    y: .value("Amount", summary.totalSpent)
                )
                .foregroundStyle(by: .value("Category", summary.category.rawValue.capitalized))
                .cornerRadius(5)
            }
        }
    }

    // Filtro dinámico para gastos
    var filteredExpenses: [Expense] {
        let allExpenses: [Expense] = visits.map {
            Expense(id: $0.id, date: $0.date, category: .consultation, amountSpent: $0.amountSpent)
        } + medications.map {
            Expense(id: $0.id, date: $0.expirationDate, category: .medication, amountSpent: $0.price)
        }

        return allExpenses.filter { expense in
            Calendar.current.isDate(expense.date, equalTo: Date(), toGranularity: selectedFilter.calendarComponent)
        }
    }

    // Resumen de gastos por categoría para el gráfico circular
    var categorySummaries: [CategorySummary] {
        let consultationTotal = filteredExpenses
            .filter { $0.category == .consultation }
            .reduce(0.0) { $0 + $1.amountSpent }

        let medicationTotal = filteredExpenses
            .filter { $0.category == .medication }
            .reduce(0.0) { $0 + $1.amountSpent }

        return [
            CategorySummary(category: .consultation, totalSpent: consultationTotal),
            CategorySummary(category: .medication, totalSpent: medicationTotal)
        ]
    }
}

// Modelo auxiliar para el gráfico circular
struct CategorySummary {
    let category: ExpenseCategory
    let totalSpent: Double
}

// Modelo auxiliar para los datos de gastos
struct Expense: Identifiable {
    let id: UUID
    let date: Date
    let category: ExpenseCategory
    let amountSpent: Double
}

enum ExpenseCategory: String, CaseIterable {
    case consultation
    case medication
}

enum TimeFilter: String, CaseIterable {
    case day
    case week
    case month
    case year

    var calendarComponent: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        }
    }
}

#Preview {
    ExpensesView()
}
