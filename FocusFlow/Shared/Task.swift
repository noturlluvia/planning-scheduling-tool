//
//  Task.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.

import Foundation
import SwiftUI

struct SubTask: Identifiable, Equatable {
    let id: UUID
    var title: String
    var timeBlocks: Double  // Updated to Double for more granular time
    var timeRemaining: Int
    var timerRunning: Bool
    var timerManager: TimerManager
    var isCompleted: Bool = false

    init(id: UUID = UUID(), title: String = "New Sub-Task", timeBlocks: Double = 1.0) {
        self.id = id
        self.title = title
        self.timeBlocks = timeBlocks
        self.timeRemaining = Int(timeBlocks * 60 * 60)  // Adjusting the time to reflect hours correctly
        self.timerRunning = false
        self.timerManager = TimerManager(timeRemaining: self.timeRemaining)  // Initialize TimerManager with correct time
        self.isCompleted = false
    }

    static func == (lhs: SubTask, rhs: SubTask) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.timeBlocks == rhs.timeBlocks &&
            lhs.timeRemaining == rhs.timeRemaining &&
            lhs.timerRunning == rhs.timerRunning &&
            lhs.isCompleted == rhs.isCompleted
    }

    mutating func startTimer(updateHandler: @escaping () -> Void) {
        timerRunning = true
        timerManager.startTimer(updateHandler: updateHandler)
    }

    mutating func stopTimer() {
        timerManager.stopTimer()
        timerRunning = false
    }
}

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    var timer: Timer?

    init(timeRemaining: Int) {
        self.timeRemaining = timeRemaining
    }

    func startTimer(updateHandler: @escaping () -> Void) {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                updateHandler()
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
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
