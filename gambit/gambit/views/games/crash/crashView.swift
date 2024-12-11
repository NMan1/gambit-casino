//
//  crashView.swift
//  gambit
//
//  Created by Nick Mantini on 11/20/24.
//

import SwiftUI
import _SpriteKit_SwiftUI
import AlertToast

struct crashView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @ObservedObject var betModel: BetModel
    @Binding var liveGameBalance: Double
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scene: crashGameScene? = nil
    @State private var gameId = "crash"
    @State private var betAmmount: Double = 1.0
    
    var body: some View {
        VStack {
            AnimatedCrashLineView()

//                Spacer()

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
                            }
                            .fixedSize()
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 65)
        }
        .background {
            backgroundView()
        }
        .onAppear {
            withAnimation(.easeIn) {
                self.accountModel.account.activeGame = gameId
            }
            
            let newScene = crashGameScene(
                liveGameBalance: $liveGameBalance,
                       size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
            newScene.scaleMode = .fill
            self.scene = newScene
            
            self.liveGameBalance = self.accountModel.account.activeCur
        }
        .onChange(of: presentationMode.wrappedValue.isPresented) {
            if !presentationMode.wrappedValue.isPresented {
                self.accountModel.account.activeGame = ""
            }
        }
    }
}
