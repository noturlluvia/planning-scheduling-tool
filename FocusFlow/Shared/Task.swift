//
//  Task.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.
//
//

import Foundation
import SwiftUI

enum Priority: String, CaseIterable, Identifiable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .low:
            return Color.green
        case .normal:
            return Color.yellow
        case .high:
            return Color.red
        }
    }
}

struct SubTask: Identifiable, Equatable {
    let id: UUID
    var title: String
    var timeBlocks: Int
    var timeRemaining: Int
    var timerRunning: Bool
    var timer: Timer?

    init(id: UUID = UUID(), title: String = "New Sub-Task", timeBlocks: Int = 2) {
        self.id = id
        self.title = title
        self.timeBlocks = timeBlocks
        self.timeRemaining = timeBlocks * 60 * 60 // Adjusting the time to reflect hours correctly
        self.timerRunning = false
    }

    mutating func startTimer(updateHandler: @escaping (SubTask) -> Void) {
        timerRunning = true

        stopTimer() // Stop any existing timer before starting a new one

        var selfCopy = self
        selfCopy.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if selfCopy.timeRemaining > 0 {
                selfCopy.timeRemaining -= 1
            } else {
                selfCopy.stopTimer()
            }
            updateHandler(selfCopy) // Trigger the UI update via the handler
        }
        self = selfCopy
    }

    mutating func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
}

struct Task: Identifiable {
    let id: UUID
    var title: String
    var startDate: Date
    var dueDate: Date
    var priority: Priority
    var subTasks: [SubTask]
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String = "New Task", startDate: Date = Date(), dueDate: Date = Date(), priority: Priority = .normal, subTasks: [SubTask] = [], isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.dueDate = dueDate
        self.priority = priority
        self.subTasks = subTasks
        self.isCompleted = isCompleted
    }
}
