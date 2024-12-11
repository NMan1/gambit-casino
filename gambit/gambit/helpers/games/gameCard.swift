//
//  gameCard.swift
//  gambit
//
//  Created by Nick Mantini on 11/20/24.
//

import SwiftUI

struct GameCard: View {
    let title: String
    let imageName: String?
    let iconName: String?
    let iconRotation: Double
    let backgroundColor: Color

    init(
        title: String,
        imageName: String? = nil,
        iconName: String? = nil,
        iconRotation: Double = 0,
        backgroundColor: Color
    ) {
        self.title = title
        self.imageName = imageName
        self.iconName = iconName
        self.iconRotation = iconRotation
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack(spacing: 0) {
            // Display image if imageName is provided
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        .rect(
                            topLeadingRadius: 11,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 11
                        )
                    )
            }

            HStack(spacing: 9) {
                if let iconName = iconName {
                    Image(iconName)
                        .rotationEffect(.degrees(iconRotation))
                }

                Text(title)
                    .font(.title3.weight(.medium))
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(RoundedCorners(color: backgroundColor, tl: imageName != nil ? 0 : 12, tr: imageName != nil ? 0 : 12, bl: 12, br: 12))
        }
    }
}
