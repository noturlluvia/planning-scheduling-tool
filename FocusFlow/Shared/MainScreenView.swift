//
//  MainScreenView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.

import SwiftUI

struct MainScreenView: View {
    @State private var tasks: [Task] = []
    @State private var showTaskCreation = false
    @State private var selectedTask: Task? = nil
    @State private var selectedSubTask: SubTask? = nil // Track the selected subtask
    @State private var showCountdown = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    sectionHeader(title: "Due Today")
                    TaskListView(
                        tasks: Binding(get: {
                            tasks.filter { Calendar.current.isDateInToday($0.dueDate) }
                        }, set: { _ in }),
                        onTaskTap: editTask,
                        onTaskDone: markTaskDone,
                        onSubTaskTap: startSubTaskTimer,
                        onSubTaskDone: markSubTaskDone
                    )

                    sectionHeader(title: "Upcoming Tasks")
                    TaskListView(
                        tasks: Binding(get: {
                            tasks.filter { $0.dueDate > Date() && !Calendar.current.isDateInToday($0.dueDate) }
                        }, set: { _ in }),
                        onTaskTap: editTask,
                        onTaskDone: markTaskDone,
                        onSubTaskTap: startSubTaskTimer,
                        onSubTaskDone: markSubTaskDone
                    )

                    sectionHeader(title: "Completed This Week")
                    TaskListView(
                        tasks: Binding(get: {
                            tasks.filter { Calendar.current.isDate($0.dueDate, equalTo: Date(), toGranularity: .weekOfYear) && $0.isCompleted }
                        }, set: { _ in }),
                        onTaskTap: editTask,
                        onTaskDone: markTaskDone,
                        onSubTaskTap: startSubTaskTimer,
                        onSubTaskDone: markSubTaskDone
                    )
                }
                .padding()
                .frame(maxWidth: .infinity) // Make use of the full width on larger screens
            }
            .navigationTitle("Your Tasks")
            .navigationBarItems(trailing: Button(action: {
                selectedTask = nil
                showTaskCreation.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showTaskCreation) {
                if let task = selectedTask {
                    TaskCreationView(task: task, onSave: updateTask)
                } else {
                    TaskCreationView(onSave: addTask)
                }
            }
            .sheet(isPresented: $showCountdown) {
                if let selectedTask = selectedTask, let selectedSubTask = selectedSubTask {
                    CountdownView(subTask: Binding(get: {
                        return selectedSubTask
                    }, set: { newSubTask in
                        if let taskIndex = tasks.firstIndex(where: { $0.id == selectedTask.id }),
                           let subTaskIndex = tasks[taskIndex].subTasks.firstIndex(where: { $0.id == newSubTask.id }) {
                            tasks[taskIndex].subTasks[subTaskIndex] = newSubTask
                        }
                    }))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper navigation style on iPad
    }

    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
    }

    private func editTask(_ task: Task) {
        selectedTask = task
        showTaskCreation = true
    }

    private func markTaskDone(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            // Update all subtasks if the task is marked as done
            tasks[index].subTasks.indices.forEach { subTaskIndex in
                tasks[index].subTasks[subTaskIndex].isCompleted = tasks[index].isCompleted
            }
        }
    }

    private func markSubTaskDone(_ task: Task, subTask: SubTask) {
        if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }),
           let subTaskIndex = tasks[taskIndex].subTasks.firstIndex(where: { $0.id == subTask.id }) {
            tasks[taskIndex].subTasks[subTaskIndex].isCompleted.toggle()

            // Check if all subtasks are done
            let allSubTasksDone = tasks[taskIndex].subTasks.allSatisfy { $0.isCompleted }
            tasks[taskIndex].isCompleted = allSubTasksDone
        }
    }

    private func addTask(_ newTask: Task) {
        tasks.append(newTask)
        selectedTask = nil
    }

    private func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }

    private func startSubTaskTimer(_ task: Task, subTask: SubTask) {
        selectedTask = task
        selectedSubTask = subTask
        showCountdown = true
    }
}
