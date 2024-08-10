//
//  CalendarView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @Binding var tasks: [Task]

    var body: some View {
        // Calendar View Implementation
        Text("Calendar View")
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(tasks: .constant([]))
    }
}

//
//struct CalendarView: View {
//    @State private var selectedDate = Date()
//    @Binding var tasks: [Task]
//
//    var body: some View {
//        VStack {
//            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(GraphicalDatePickerStyle())
//                .padding()
//
//            List {
//                ForEach(tasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }) { task in
//                    Text(task.title)
//                }
//            }
//        }
//        .navigationTitle("Calendar")
//    }
//}
//
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView(tasks: .constant([
//            Task(title: "Task 1", startDate: Date(), dueDate: Date(), priority: .normal, subTasks: []),
//            Task(title: "Task 2", startDate: Date(), dueDate: Date().addingTimeInterval(86400), priority: .high, subTasks: [])
//        ]))
//    }
//}
