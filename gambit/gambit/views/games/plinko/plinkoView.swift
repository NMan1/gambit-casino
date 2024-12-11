//
//  crashView.swift
//  gambit
//
//  Created by Nick Mantini on 11/20/24.
//

import SwiftUI
import SpriteKit
import AlertToast

struct plinkoView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @ObservedObject var betModel: BetModel
    @Binding var liveGameBalance: Double
    
    @Environment(\.presentationMode) var presentationMode

    @State private var scene: plinkoGameScene? = nil
    @State private var gameId = "plinko"
    @State private var betAmmount: Double = 1.0
    @State private var autoSpinCount = 0
    @State private var isAutoSpinning = false
    
    var body: some View {
        ZStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()

                    HStack {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Bet Amount")
                                    .font(.title2.bold())
                                
                                TextField("Bet Amount", value: self.$betAmmount, formatter: currencyFormatter)
                                    .keyboardType(.numberPad)
                                    .padding(8)
                                    .font(.title2)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.white, lineWidth: 1)
                                    )
                                    .fixedSize()
                            }
                            
                            HStack(spacing: 10) {
                                VerticalStepper(value: $betAmmount, range: 0.00...100000.0, step: 0.1, color: .brightGreen, bgColor: .gray)
                               
                                Text("Bet")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 25)
                                    .frame(maxWidth: .infinity)
                                    .background(.brightGreen)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        betModel.processBet(gameId: self.gameId, activeCur:   self.accountModel.account.setCurrency, betAmmount: self.betAmmount) { error, betResponse in
                                            if let (_, errorMsg) = error {
                                                alertViewModel.presentToast(
                                                    toast: AlertToast(displayMode: .hud, type: .error(.red), title: errorMsg)
                                                )
                                            } else if let bet = betResponse {
                                                self.liveGameBalance = self.liveGameBalance - bet.betAmount
                                                scene.dropBall(multi: bet.multi, liveBalance: bet.newBalance)
                                            }
                                        }
                                    }
                                    .fixedSize()
                            }
                        }
                        
//                        Spacer()
//                        
//                        VStack(spacing: 35) {
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text("Auto bet")
//                                    .font(.title2.bold())
//                                
//                                VStack(spacing: 10) {
//                                    TextField("", value: self.$autoSpinCount, format: .number)
//                                        .keyboardType(.numberPad)
//                                        .padding(8)
//                                        .font(.title2)
//                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 8)
//                                                .stroke(.white, lineWidth: 1)
//                                        )
//                                        .frame(maxWidth: UIScreen.main.bounds.width*0.23)
//                                }
//                            }
//                            
//                            Text("Start")
//                                .font(.title2.bold())
//                                .foregroundColor(.white)
//                                .padding(.vertical, 15)
//                                .padding(.horizontal, 25)
//                                .frame(maxWidth: .infinity)
//                                .background(.brightGreen)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                                .fixedSize()
//                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 65)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn) {
                self.accountModel.account.activeGame = gameId
            }
            
            let newScene = plinkoGameScene(
                liveGameBalance: $liveGameBalance,
                       size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )    
            newScene.scaleMode = .fill
            self.scene = newScene // Keep a reference to the scene
            
            self.liveGameBalance = self.accountModel.account.activeCur
        }
        .onChange(of: presentationMode.wrappedValue.isPresented) {
            if !presentationMode.wrappedValue.isPresented {
                self.accountModel.account.activeGame = ""
            }
        }
    }
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

struct MultiplierSlot {
    let multiplier: Double
    let color: Color
}
