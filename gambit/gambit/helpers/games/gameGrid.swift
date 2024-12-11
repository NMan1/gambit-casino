//
//  gameGrid.swift
//  gambit
//
//  Created by Nick Mantini on 11/20/24.
//

import SwiftUI

struct GameGrid: View {
    @State private var navigateToPlinko = false
    @State private var dontNav = false
    
    let items: [(title: String, imageName: String?, iconName: String?, iconRotation: Double, backgroundColor: Color, destination: AnyView?)]
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items, id: \.title) { item in
                if let destination = item.destination {
                    NavigationLink(destination: destination) {
                        GameCard(
                            title: item.title,
                            imageName: item.imageName,
                            iconName: item.iconName,
                            iconRotation: item.iconRotation,
                            backgroundColor: item.backgroundColor
                        )
                    }
                   .buttonStyle(.plain)
                } else {
                    // Just render the card without navigation
                    GameCard(
                        title: item.title,
                        imageName: item.imageName,
                        iconName: item.iconName,
                        iconRotation: item.iconRotation,
                        backgroundColor: item.backgroundColor
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear {
//            navigateToPlinko = true
        }
    }
}
