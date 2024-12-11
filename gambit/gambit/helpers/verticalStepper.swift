//
//  verticalStepper.swift
//  gambit
//
//  Created by Nick Mantini on 11/21/24.
//

import SwiftUI

struct VerticalStepper<T: Numeric & Comparable>: View {
    @Binding var value: T
    var range: ClosedRange<T>
    var step: T // Step value
    var color: Color = .white // Customizable color for icons and text
    var bgColor: Color = .gray // Background color for the stepper

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                let newValue = value + step
                if newValue <= range.upperBound {
                    value = newValue
                }
            }) {
                Image(systemName: "plus")
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(height: 25)
            }
            
            Divider()
                .frame(width: 30)
            
            Button(action: {
                let newValue = value - step
                if newValue >= range.lowerBound {
                    value = newValue
                }
            }) {
                Image(systemName: "minus")
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(height: 25)
            }
        }
        .padding(.all, 5)
        .background(RoundedRectangle(cornerRadius: 10).fill(bgColor.opacity(0.2)))
        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
