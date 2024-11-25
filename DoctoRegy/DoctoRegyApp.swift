//
//  DoctoRegyApp.swift
//  DoctoRegy
//
//  Created by Marco Alonso Rodriguez on 25/11/24.
//

import SwiftUI
import SwiftData

@main
struct DoctoRegyApp: App {
    init() {
        requestNotificationPermissions()
    }
     
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: [Visit.self, Medication.self, Reminder.self])
        }
    }
    
    func requestNotificationPermissions() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permissions: \(error)")
                } else if granted {
                    print("Notification permissions granted")
                } else {
                    print("Notification permissions denied")
                }
            }
        }
}
