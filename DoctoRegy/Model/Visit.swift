//
//  Visit.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import Foundation
import SwiftData

@Model
class Visit: Identifiable {
    var id: UUID
    var date: Date
    var doctorName: String
    var diagnosis: String
    var amountSpent: Double

    init(id: UUID = UUID(), date: Date, doctorName: String, diagnosis: String, amountSpent: Double) {
        self.id = id
        self.date = date
        self.doctorName = doctorName
        self.diagnosis = diagnosis
        self.amountSpent = amountSpent
    }
}

@Model
class Medication: Identifiable {
    var id: UUID
    var name: String
    var price: Double // Cambiado de String a Double
    var quantity: String
    var purchaseDate: Date

    init(id: UUID = UUID(), name: String, price: Double, quantity: String, expirationDate: Date) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.purchaseDate = expirationDate
    }
}

@Model
class Reminder: Identifiable {
    var id: UUID
    var medicationId: UUID
    var dosage: String
    var timeInterval: TimeInterval
    var repeatCount: Int

    init(id: UUID = UUID(), medicationId: UUID, dosage: String, timeInterval: TimeInterval, repeatCount: Int) {
        self.id = id
        self.medicationId = medicationId
        self.dosage = dosage
        self.timeInterval = timeInterval
        self.repeatCount = repeatCount
    }
}

@Model
class Recipe: Identifiable {
    var id: UUID
    var photo: Data

    init(id: UUID = UUID(), photo: Data) {
        self.id = id
        self.photo = photo
    }
}

class MockData {
    static let sampleMedication = Medication(
        name: "Ibuprofen",
        price: 300,
        quantity: "200ml",
        expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 30) // 30 días a partir de hoy
    )
    
    static let sampleVisit = Visit(
            date: Date(),
            doctorName: "Dr. John Doe",
            diagnosis: "Common Cold",
            amountSpent: 150.0
        )
    
    static let medications: [Medication] = [
        Medication(name: "Paracetamol", price: 200.98, quantity: "500mg", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 30)),
           Medication(name: "Ibuprofen", price: 250.4, quantity: "200mg", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 60)),
           Medication(name: "Sensidex", price: 300.56, quantity: "100ml", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 90))
       ]
    
    static let sampleReminder = Reminder(
            id: UUID(),
            medicationId: UUID(),
            dosage: "2.5 ml",
            timeInterval: 8 * 3600,
            repeatCount: 15
        )
}
