//
//  CountdownView.swift
//  FocusFlow
//
//  Created by Lluvia Jing on 8/9/24.
//

import SwiftUI

struct CountdownView: View {
    @Binding var subTask: SubTask

    var body: some View {
        VStack {
            Text(subTask.title)
                .font(.title)
                .padding(.bottom, 20)

            Text("Remaining Focus Time: \(formatTime(timeRemaining: subTask.timerManager.timeRemaining))")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            HStack {
                Button("Stop Timer") {
                    subTask.stopTimer()
                }
                .padding()
                .background(Color.red.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Resume Timer") {
                    subTask.startTimer {
                        self.subTask = subTask
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .onAppear {
            if !subTask.timerRunning {
                // Ensure the latest timeRemaining is used
                subTask.timeRemaining = Int(subTask.timeBlocks * 3600)
                subTask.startTimer {
                    self.subTask = subTask
                }
            }
        }
        .onDisappear {
            if subTask.timerRunning {
                subTask.stopTimer()
            }
        }
    }

    private func formatTime(timeRemaining: Int) -> String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct CountdownView_Previews: PreviewProvider {
    @State static var subTask = SubTask(title: "Sample Sub-Task", timeBlocks: 1.0) // Test with 1 hour

    static var previews: some View {
        CountdownView(subTask: $subTask)
    }
}
