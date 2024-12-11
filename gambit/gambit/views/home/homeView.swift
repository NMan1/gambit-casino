//
//  messageView.swift
//  node
//
//  Created by Nick Mantini on 10/28/24.
//

import SwiftUI
import AlertToast

struct homeView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @ObservedObject var betModel: BetModel
    @Binding var liveGameBalance: Double
    
    var body: some View {
        VStack(spacing: 0) {
            headerView(accountModel: self.accountModel)
                .environmentObject(alertViewModel)
                .padding(.horizontal, 17)
            
            ScrollView(showsIndicators: false) {
                casinoHomePage
                
                Spacer()
            }
            .padding([.horizontal, .top], 17)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            backgroundView()
        }
    }
    
    @ViewBuilder private var casinoHomePage: some View {
        VStack(spacing: 13) {
            GameGrid(items: [
                (title: "Slots", imageName: "exploreCasino", iconName: "slotsIcon", iconRotation: 0, backgroundColor: .duskGreen, destination: nil),
                (title: "Sportsbook", imageName: "exploreSportsBook", iconName: "basketball.fill", iconRotation: -15, backgroundColor: .duskGreen, destination: nil)
            ])
            
            GameCard(
                title: "Gambit Originals",
                iconName: "flame.fill",
                backgroundColor: .duskGreen
            )

            GameGrid(items: [
                (title: "Crash", imageName: "crash", iconName: nil, iconRotation: 0, backgroundColor: .duskGreen, destination: AnyView(crashView(accountModel: self.accountModel, betModel: self.betModel, liveGameBalance: self.$liveGameBalance)
                    .environmentObject(self.alertViewModel))),
                (title: "Dice", imageName: "dice", iconName: nil, iconRotation: 0, backgroundColor: .duskGreen, destination: AnyView(diceView(accountModel: self.accountModel, betModel: self.betModel)
                    .environmentObject(alertViewModel))),
                (title: "Plinko", imageName: "plinko", iconName: nil, iconRotation: 0, backgroundColor: .duskGreen, destination: AnyView(plinkoView(accountModel: self.accountModel, betModel: self.betModel, liveGameBalance: self.$liveGameBalance)
                    .environmentObject(alertViewModel))),
                (title: "Mines", imageName: "mines", iconName: nil, iconRotation: 0, backgroundColor: .duskGreen, destination: AnyView(minesView(accountModel: self.accountModel, betModel: self.betModel)
                    .environmentObject(alertViewModel))),
            ])
        }
    }
}
