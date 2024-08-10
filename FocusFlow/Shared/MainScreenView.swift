//
//  MainScreenView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.
//

import SwiftUI

struct MainScreenView: View {
    @State private var tasks: [Task] = []
    @State private var showTaskCreation = false
    @State private var selectedTask: Task? = nil
    @State private var selectedSubTask: SubTask? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Due Today")
                        .font(.headline)
                    
                    TaskListView(tasks: Binding(get: {
                        tasks.filter { Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
                    }, set: { _ in }),
                    onTaskTap: editTask,
                    onTaskDone: markTaskDone)
                    
                    Text("Upcoming Tasks")
                        .font(.headline)
                    
                    TaskListView(tasks: Binding(get: {
                        tasks.filter { $0.dueDate > Date() && !Calendar.current.isDateInToday($0.dueDate) && !$0.isCompleted }
                    }, set: { _ in }),
                    onTaskTap: editTask,
                    onTaskDone: markTaskDone)
                    
                    Text("Completed This Week")
                        .font(.headline)
                    
                    TaskListView(tasks: Binding(get: {
                        tasks.filter { $0.isCompleted && Calendar.current.isDate($0.dueDate, equalTo: Date(), toGranularity: .weekOfYear) }
                    }, set: { _ in }),
                    onTaskTap: editTask,
                    onTaskDone: { _ in })
                }
                .padding()
            }
            .navigationTitle("Your Tasks")
            .navigationBarItems(trailing: Button(action: {
                selectedTask = nil
                showTaskCreation.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showTaskCreation) {
                TaskCreationView(task: selectedTask, onSave: { newTask in
                    if let existingTask = tasks.firstIndex(where: { $0.id == newTask.id }) {
                        tasks[existingTask] = newTask
                    } else {
                        tasks.append(newTask)
                    }
                })
            }
            .sheet(item: $selectedSubTask) { subTask in
                CountdownView(subTask: .constant(subTask))
            }
        }
    }
    
    private func editTask(_ task: Task) {
        selectedTask = task
        showTaskCreation = true
    }
    
    private func markTaskDone(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

