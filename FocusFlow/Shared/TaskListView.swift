//
//  TaskListView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.

import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    var onTaskTap: (Task) -> Void
    var onTaskDone: (Task) -> Void
    var onSubTaskTap: (Task, SubTask) -> Void
    var onSubTaskDone: (Task, SubTask) -> Void

    var body: some View {
        ForEach(tasks) { task in
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        onTaskDone(task)
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.priority.color)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text(task.title)
                        .strikethrough(task.isCompleted)
                        .font(.title3)

                    Spacer()

                    Button(action: {
                        onTaskTap(task)
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .padding(.leading, 5)
                }
                .padding(.bottom, 5) // Add some spacing below the task title

                VStack(alignment: .leading) {
                    ForEach(task.subTasks) { subTask in
                        HStack {
                            Button(action: {
                                onSubTaskDone(task, subTask)
                            }) {
                                Image(systemName: subTask.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Text("\(subTask.title) (\(String(format: "%.1f", subTask.timeBlocks)) \(subTask.timeBlocks > 1 ? "hours" : "hour"))")  // Fix decimal places

                            Spacer()

                            Button(action: {
                                onSubTaskTap(task, subTask)
                            }) {
                                Text("Start Timer")
                            }
                            .font(.caption)
                        }
                    }
                }
                .padding(.leading, 30) // Adjust padding to align subtasks correctly under the task
            }
            .padding(.vertical, 5)
        }
        .onDelete { indexSet in
            tasks.remove(atOffsets: indexSet)
        }
    }
}
