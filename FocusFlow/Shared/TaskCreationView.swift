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
    @State private var showingTimeBlockInput = false
    @State private var tempTimeBlocks: Double = 1.0  // Temporary holder for input
    @State private var selectedSubTaskIndex: Int? = nil  // To identify which subtask is being edited

    @Environment(\.presentationMode) var presentationMode
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
                        HStack {
                            VStack(alignment: .leading) {
                                TextField("Sub-Task Name", text: $subTasks[index].title)
                                Text("Time Blocks: \(subTasks[index].timeBlocks, specifier: "%.1f") hours")
                            }
                            Spacer()
                            Button("Edit") {
                                self.tempTimeBlocks = subTasks[index].timeBlocks
                                self.selectedSubTaskIndex = index
                                self.showingTimeBlockInput = true
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .onDelete(perform: deleteSubTask)
                    
                    Button("Add New Sub-Task") {
                        self.tempTimeBlocks = 1.0  // Default starting value
                        self.selectedSubTaskIndex = nil
                        self.showingTimeBlockInput = true
                    }
                }
            }
            .navigationBarTitle(task == nil ? "Create New Task" : "Edit Task")
            .navigationBarItems(trailing: Button("Save") {
                onSave(Task(id: task?.id ?? UUID(), title: title, startDate: startDate, dueDate: dueDate, priority: priority, subTasks: subTasks, isCompleted: task?.isCompleted ?? false))
                presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showingTimeBlockInput) {
            VStack {
                Text("Set Time Blocks for Sub-Task")
                Stepper("Time Blocks: \(tempTimeBlocks, specifier: "%.1f") hours", value: $tempTimeBlocks, in: 0.5...10, step: 0.5)
                Button("Confirm") {
                    if let index = selectedSubTaskIndex {
                        subTasks[index].timeBlocks = tempTimeBlocks
                    } else {
                        let newSubTask = SubTask(title: "", timeBlocks: tempTimeBlocks)
                        subTasks.append(newSubTask)
                    }
                    showingTimeBlockInput = false
                }
                .padding()
            }
            .frame(width: 300, height: 200) // Adjust the size of the sheet if needed
            .padding()
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

    private func deleteSubTask(at offsets: IndexSet) {
        subTasks.remove(atOffsets: offsets)
    }
}

struct TaskCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCreationView(task: Task(title: "Test Task"), onSave: { _ in })
    }
}
