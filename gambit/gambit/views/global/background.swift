//
//  background.swift
//  gambit
//
//  Created by Nick Mantini on 11/18/24.
//

import SwiftUI


struct backgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "0f212e")!,
                    Color(hex: "0e1e29")!,
                    Color(hex: "0c1a25")!,
                    Color(hex: "0b1720")!,
                    Color(hex: "09141c")!,
                    Color(hex: "081117")!,
                    Color(hex: "060d12")!,
                    Color(hex: "081117")!,
                    Color(hex: "09141c")!,
                    Color(hex: "0b1720")!,
                    Color(hex: "0c1a25")!,
                    Color(hex: "0e1e29")!,
                    Color(hex: "0f212e")!,
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

