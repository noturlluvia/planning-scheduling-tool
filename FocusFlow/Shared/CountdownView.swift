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
                .font(.largeTitle)
                .padding()

            Text("Time Remaining: \(formatTime(timeRemaining: subTask.timeRemaining))")
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()

            Button(subTask.timerRunning ? "Stop Timer" : "Start Timer") {
                if subTask.timerRunning {
                    subTask.stopTimer()
                } else {
                    subTask.startTimer { updatedSubTask in
                        self.subTask = updatedSubTask
                    }
                }
            }
            .padding(.top, 20)
        }
        .onAppear {
            // Automatically start the timer when the view appears
            if !subTask.timerRunning {
                subTask.startTimer { updatedSubTask in
                    self.subTask = updatedSubTask
                }
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
    static var previews: some View {
        CountdownView(subTask: .constant(SubTask(title: "Sample Sub-Task", timeBlocks: 2)))
    }
}

