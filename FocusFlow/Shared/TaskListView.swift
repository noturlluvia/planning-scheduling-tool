//
//  TaskListView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.
//

import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    var onTaskTap: (Task) -> Void
    var onTaskDone: (Task) -> Void
    
    var body: some View {
        ForEach(tasks) { task in
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .fill(task.priority.color)
                        .frame(width: 10, height: 10)
                    Text(task.title)
                        .font(.headline)
                    Spacer()
                    Button(action: { onTaskDone(task) }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 2)
                
                ForEach(task.subTasks) { subTask in
                    HStack {
                        Text(subTask.title)
                        Spacer()
                        Button(action: {
                            // Call function to open CountdownView and start timer
                            showCountdownView(for: subTask)
                        }) {
                            Text("Start Timer")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.bottom, 8)
            .onTapGesture {
                onTaskTap(task)
            }
        }
    }

    private func showCountdownView(for subTask: SubTask) {
        // Open the CountdownView here (example placeholder function)
        // This would likely involve updating a binding in the parent view to show a sheet
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: .constant([Task(title: "Sample Task")]), onTaskTap: { _ in }, onTaskDone: { _ in })
    }
}
