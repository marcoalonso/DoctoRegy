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
    @State private var tipoGrafico: TipoGrafico = .dona
    @State private var filtroSeleccionado: TimeFilter = .dia
    @State private var fechaReferencia: Date = Date()

    private var dynamicHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight * 0.6
    }

    private var gastosFiltradosYAgrupados: [CategoriaGasto] {
        let calendar = Calendar.current

        // Filtrar y procesar visitas
        let visitasFiltradas = visits.filter { visit in
            switch filtroSeleccionado {
            case .dia:
                return calendar.isDate(visit.date, inSameDayAs: fechaReferencia)
            case .semana:
                return calendar.isDate(visit.date, equalTo: fechaReferencia, toGranularity: .weekOfYear)
            case .mes:
                return calendar.isDate(visit.date, equalTo: fechaReferencia, toGranularity: .month)
            case .anio:
                return calendar.isDate(visit.date, equalTo: fechaReferencia, toGranularity: .year)
            }
        }
        .reduce(0.0) { $0 + $1.amountSpent }

        // Filtrar y procesar medicamentos
        let medicamentosFiltrados = medications.filter { medication in
            switch filtroSeleccionado {
            case .dia:
                return calendar.isDate(medication.purchaseDate, inSameDayAs: fechaReferencia)
            case .semana:
                return calendar.isDate(medication.purchaseDate, equalTo: fechaReferencia, toGranularity: .weekOfYear)
            case .mes:
                return calendar.isDate(medication.purchaseDate, equalTo: fechaReferencia, toGranularity: .month)
            case .anio:
                return calendar.isDate(medication.purchaseDate, equalTo: fechaReferencia, toGranularity: .year)
            }
        }
        .reduce(0.0) { $0 + $1.price }

        // Crear datos para el gráfico
        return [
            CategoriaGasto(categoria: "Consultation", total: visitasFiltradas),
            CategoriaGasto(categoria: "Medication", total: medicamentosFiltrados)
        ]
    }

    var body: some View {
        VStack {
            Picker("Filtrar por", selection: $filtroSeleccionado) {
                ForEach(TimeFilter.allCases, id: \.self) { filtro in
                    Text(filtro.rawValue.capitalized).tag(filtro)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Button(action: mostrarPeriodoAnterior) {
                    Label("", systemImage: "chevron.left")
                }

                Spacer()

                Text(descripcionPeriodo)
                    .font(.headline)
                    .foregroundColor(.gray)

                Spacer()

                if !esPeriodoActual {
                    Button(action: mostrarPeriodoPosterior) {
                        Label("", systemImage: "chevron.right")
                    }
                }
            }
            .padding(.horizontal)

            Picker("Tipo de gráfico", selection: $tipoGrafico) {
                ForEach(TipoGrafico.allCases, id: \.self) { tipo in
                    Text(tipo.titulo).tag(tipo)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            switch tipoGrafico {
            case .dona:
                GraficoDona(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
            case .barras:
                GraficoBarras(gastos: gastosFiltradosYAgrupados, height: dynamicHeight)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Expenses")
    }

    private var descripcionPeriodo: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")

        switch filtroSeleccionado {
        case .dia:
            formatter.dateFormat = "d 'de' MMMM"
            return formatter.string(from: fechaReferencia)
        case .semana:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fechaReferencia))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            formatter.dateFormat = "d MMM"
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        case .mes:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: fechaReferencia)
        case .anio:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: fechaReferencia)
        }
    }

    private var esPeriodoActual: Bool {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            return calendar.isDateInToday(fechaReferencia)
        case .semana:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .weekOfYear)
        case .mes:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .month)
        case .anio:
            return calendar.isDate(fechaReferencia, equalTo: Date(), toGranularity: .year)
        }
    }

    private func mostrarPeriodoAnterior() {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            fechaReferencia = calendar.date(byAdding: .day, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .semana:
            fechaReferencia = calendar.date(byAdding: .weekOfYear, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .mes:
            fechaReferencia = calendar.date(byAdding: .month, value: -1, to: fechaReferencia) ?? fechaReferencia
        case .anio:
            fechaReferencia = calendar.date(byAdding: .year, value: -1, to: fechaReferencia) ?? fechaReferencia
        }
    }

    private func mostrarPeriodoPosterior() {
        let calendar = Calendar.current
        switch filtroSeleccionado {
        case .dia:
            fechaReferencia = calendar.date(byAdding: .day, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .semana:
            fechaReferencia = calendar.date(byAdding: .weekOfYear, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .mes:
            fechaReferencia = calendar.date(byAdding: .month, value: 1, to: fechaReferencia) ?? fechaReferencia
        case .anio:
            fechaReferencia = calendar.date(byAdding: .year, value: 1, to: fechaReferencia) ?? fechaReferencia
        }
    }
}

// Estructura para representar el total por categoría
struct CategoriaGasto: Identifiable {
    let id = UUID()
    let categoria: String
    let total: Double
}

enum TipoGrafico: String, CaseIterable {
    case dona
    case barras

    var titulo: String {
        switch self {
        case .dona: return "Dona"
        case .barras: return "Barras"
        }
    }
}

enum TimeFilter: String, CaseIterable {
    case dia
    case semana
    case mes
    case anio

    var calendarComponent: Calendar.Component {
        switch self {
        case .dia: return .day
        case .semana: return .weekOfYear
        case .mes: return .month
        case .anio: return .year
        }
    }
}


