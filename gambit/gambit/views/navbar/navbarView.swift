//
//  narbar.swift
//  gambit
//
//  Created by Nick Mantini on 11/16/24.
//

import SwiftUI

struct navbarView: View {
    @Binding var selectedTab: Tab
        
    var body: some View {
        HStack {
            Spacer()

            TabBarButton(
                icon: "suit.club.fill",
                text: "Home",
                isSelected: selectedTab == .home,
                action: { selectedTab = .home }
            )
            
            Spacer()

            TabBarButton(
                icon: "star.fill",
                text: "Vip",
                isSelected: selectedTab == .vip,
                action: { selectedTab = .vip }
            )
            
            Spacer()

            TabBarButton(
                icon: "bubble.left.and.bubble.right.fill",
                text: "Chat",
                isSelected: selectedTab == .chat,
                action: { selectedTab = .chat }
            )
            
            Spacer()
            
            TabBarButton(
                icon: "rectangle.grid.2x2.fill",
                text: "Bets",
                isSelected: selectedTab == .bets,
                action: { selectedTab = .bets }
            )
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(.lighterBlack)
    }
}

struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : .gray)
            
            Text(text)
                .font(.caption.bold())
                .foregroundColor(isSelected ? .white : .gray)
        }
        .padding(.horizontal, 15)
        .onTapGesture {
            action()
        }
    }
}

enum Tab: String {
    case home
    case vip
    case bets
    case chat
}
