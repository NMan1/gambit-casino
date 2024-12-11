//
//  gambitApp.swift
//  gambit
//
//  Created by Nick Mantini on 11/13/24.
//

import SwiftUI

@main
struct gambitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(AlertViewModel())
        }
    }
}
