//
//  TimerApp.swift
//  Timer
//
//  Created by user on 04/11/24.
//

import SwiftUI

@main
struct TimerApp: App {
    @StateObject private var timerModel = TimerModel()

    var body: some Scene {
        WindowGroup {
            TimerView()
                .environmentObject(timerModel)
        }
    }
}
