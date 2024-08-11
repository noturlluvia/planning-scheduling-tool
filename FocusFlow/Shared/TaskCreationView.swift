//
//  TaskCreationView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.

import SwiftUI

struct TaskCreationView: View {
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var dueDate: Date = Date()
    @State private var priority: Priority = .normal
    @State private var subTasks: [SubTask] = []
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    var task: Task?
    var onSave: (Task) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $title)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized).tag(priority)
                    }
                }

                Section(header: Text("Sub-Tasks")) {
                    ForEach(subTasks.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            TextField("Sub-Task Name", text: $subTasks[index].title)
                            Stepper(value: $subTasks[index].timeBlocks, in: 0.5...10, step: 0.5) {
                                Text("Time Blocks: \(String(format: "%.1f", subTasks[index].timeBlocks)) hours")
                            }
                        }
                    }
                    .onDelete(perform: deleteSubTask)

                    Button(action: addSubTask) {
                        Label("Add Sub-Task", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle(task == nil ? "Create New Task" : "Edit Task")
            .navigationBarItems(trailing: Button("Save") {
                let newTask = Task(id: task?.id ?? UUID(), title: title, startDate: startDate, dueDate: dueDate, priority: priority, subTasks: subTasks, isCompleted: task?.isCompleted ?? false)
                onSave(newTask)
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            })
        }
        .onAppear {
            if let task = task {
                title = task.title
                startDate = task.startDate
                dueDate = task.dueDate
                priority = task.priority
                subTasks = task.subTasks
            }
        }
    }

    private func addSubTask() {
        subTasks.append(SubTask(title: "New Sub-Task", timeBlocks: 1.0)) // Default to 1 hour
    }

    private func deleteSubTask(at offsets: IndexSet) {
        subTasks.remove(atOffsets: offsets)
    }
}

struct TaskCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCreationView(task: Task(title: "Test Task"), onSave: { _ in })
    }
}
