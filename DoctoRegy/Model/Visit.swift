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
    var mainSubstance: String?
    var quantity: String
    var expirationDate: Date
    var photo: Data? // Almacena la imagen en formato Data

    init(id: UUID = UUID(), name: String, mainSubstance: String?, quantity: String, expirationDate: Date, photo: Data? = nil) {
        self.id = id
        self.name = name
        self.mainSubstance = mainSubstance
        self.quantity = quantity
        self.expirationDate = expirationDate
        self.photo = photo
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
        mainSubstance: "Ibuprofen",
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
           Medication(name: "Paracetamol", mainSubstance: "Acetaminophen", quantity: "500mg", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 30)),
           Medication(name: "Ibuprofen", mainSubstance: "Ibuprofen", quantity: "200mg", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 60)),
           Medication(name: "Sensidex", mainSubstance: "Dextromethorphan", quantity: "100ml", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 90))
       ]
    
    static let sampleReminder = Reminder(
            id: UUID(),
            medicationId: UUID(),
            dosage: "2.5 ml",
            timeInterval: 8 * 3600,
            repeatCount: 15
        )
}
