//
//  ReminderDetailView.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI

struct ReminderDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var reminder: Reminder

    @State private var pendingNotifications: [UNNotificationRequest] = []

    var body: some View {
        List {
            ForEach(pendingNotifications, id: \.identifier) { request in
                VStack(alignment: .leading) {
                    Text(request.content.title)
                        .font(.headline)
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                       let nextTriggerDate = trigger.nextTriggerDate() {
                        Text("Scheduled for: \(nextTriggerDate, style: .date) at \(nextTriggerDate, style: .time)")
                            .font(.caption)
                    } else {
                        Text("Trigger: Unknown").font(.caption)
                    }
                }
            }
            .onDelete(perform: deleteNotification)
        }
        .navigationTitle("Reminder Details")
        .onAppear {
            fetchPendingNotifications()
        }
    }

    func fetchPendingNotifications() {
        let identifiers = (0..<reminder.repeatCount).map { "\(reminder.id.uuidString)_\($0)" }
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.pendingNotifications = requests.filter { identifiers.contains($0.identifier) }
            }
        }
    }

    func deleteNotification(at offsets: IndexSet) {
        offsets.forEach { index in
            let notificationId = pendingNotifications[index].identifier
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
            pendingNotifications.remove(at: index)
        }
    }
}

#Preview {
    ReminderDetailView(reminder: MockData.sampleReminder)
}
