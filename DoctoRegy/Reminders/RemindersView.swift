//
//  RemindersView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//
import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    @Query var reminders: [Reminder]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingReminder = false

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink(destination: ReminderDetailView(reminder: reminder)) {
                        VStack(alignment: .leading) {
                            if let medicationName = getMedicationName(for: reminder.medicationId) {
                                Text("\(reminder.dosage) - Suministrar: \(medicationName)")
                                    .font(.headline)
                                Text("Cada \(Int(reminder.timeInterval / 3600)) horas por \(reminder.repeatCount / Int(24 / (reminder.timeInterval / 3600))) días")
                                    .font(.subheadline)
                            } else {
                                Text("Medicamento no encontrado").font(.caption)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
            }
            .onAppear(perform: {
                printPendingNotifications()
            })
            .navigationTitle("Reminders")
            .toolbar {
                Button(action: { isAddingReminder = true }) {
                    Label("Add Reminder", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isAddingReminder) {
                AddReminderView(medications: fetchAllMedications()) { newReminder in
                    addReminder(newReminder)
                }
            }
        }
    }

    func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending Notifications: \(requests.count)")
            for request in requests {
                print("ID: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                print("Trigger: \(String(describing: request.trigger))")
                print("-----------------------------")
            }
        }
    }
    
    func deleteReminder(at offsets: IndexSet) {
        offsets.forEach { index in
            let reminder = reminders[index]
            
            // 1. Eliminar el recordatorio de SwiftData
            modelContext.delete(reminder)
            do {
                try modelContext.save()
            } catch {
                print("Failed to delete reminder from SwiftData: \(error)")
            }
            deleteNotifications(for: reminder)
        }
    }
    
    private func deleteNotifications(for reminder: Reminder) {
        let identifiers = (0..<reminder.repeatCount).map { "\(reminder.id.uuidString)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func addReminder(_ newReminder: Reminder) {
        do {
            modelContext.insert(newReminder)
            try modelContext.save()
            
            if let medicationName = getMedicationName(for: newReminder.medicationId) {
                scheduleReminderNotifications(for: newReminder, medicationName: medicationName)
            }
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }

    func fetchAllMedications() -> [Medication] {
        // Crear un descriptor de búsqueda vacío para traer todos los medicamentos
        let fetchDescriptor = FetchDescriptor<Medication>()
        do {
            // Realizar la consulta en el contexto del modelo
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch medications: \(error)")
            return []
        }
    }

    func getMedicationName(for medicationId: UUID) -> String? {
        // Busca el nombre del medicamento asociado al ID.
        return fetchAllMedications().first(where: { $0.id == medicationId })?.name
    }
    
    func scheduleReminderNotifications(for reminder: Reminder, medicationName: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        let startDate = Date() // Fecha de inicio (ahora)
        
        for i in 0..<reminder.repeatCount {
            let triggerDate: Date
            
            // Si es el primer recordatorio, programa para 30 segundos después
            if i == 0 {
                triggerDate = startDate.addingTimeInterval(30)
            } else {
                // Los demás se programan según el intervalo
                triggerDate = startDate.addingTimeInterval(reminder.timeInterval * Double(i))
            }
            
            let content = UNMutableNotificationContent()
            content.title = "\(reminder.dosage) - Suministrar: \(medicationName)"
            content.body = "Es hora de tomar tu medicamento."
            content.sound = UNNotificationSound.default
            
            if content.title.isEmpty || content.body.isEmpty {
                print("Error: Notification content is invalid")
            }
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate),
                repeats: false
            )
            
            print("Scheduling notification for: \(triggerDate)")
            
            let request = UNNotificationRequest(
                identifier: "\(reminder.id.uuidString)_\(i)", // Identificador único por instancia
                content: content,
                trigger: trigger
            )
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled with ID: \(request.identifier)")
                }
            }
        }
    }
}


#Preview {
    RemindersView()
}
