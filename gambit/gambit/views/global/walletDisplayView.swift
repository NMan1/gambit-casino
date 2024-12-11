//
//  walletDisplayView.swift
//  gambit
//
//  Created by Nick Mantini on 11/30/24.
//

import SwiftUI

struct walletDisplayView: View {
    @ObservedObject var accountModel: AccountModel

    @Binding var liveGameBalance: Double?
    
    @State private var firstHStackHeight: CGFloat = 0
    @State private var mainHStackWidth: CGFloat = 0
    @State private var animateHeight: CGFloat = 0
    @State private var currencyToggle: Bool = false
    @State private var animateToggle: Bool = false
    
    init(accountModel: AccountModel, liveGameBalance: Binding<Double?> = .constant(nil)) {
        self.accountModel = accountModel
        self._liveGameBalance = liveGameBalance
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 5) {
                HStack(spacing: 2) {
                    let displayValue = liveGameBalance == nil ? self.accountModel.account.activeCur : liveGameBalance!
                    let formatedDisplayValue = displayValue > 1000 ? String(format: "%.0f", displayValue) : String(format: "%.2f", displayValue)
                    
                    Text(formatedDisplayValue)
                        .font(.headline.weight(.bold))
                    
                    Image(systemName: "guaranisign")
                        .bold()
                        .imageScale(.small)
                        .foregroundStyle(self.accountModel.account.setCurrency == .gambitCoin ? .yellow : .brightGreen)
                }
                .scaleEffect(animateToggle ? 0.96 : 1.0)
                
                Image(systemName: "chevron.down")
                    .rotationEffect(self.currencyToggle ? .degrees(-180) : .degrees(0))
                    .scaleEffect(0.8)
                    .padding(.top, 2)
                    .frame(alignment: .bottomTrailing)
                    .bold()
                    .imageScale(.small)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background {
                RoundedCorners(color: .deepCharcoal, tl: 6, bl: currencyToggle ? 0 : 6)
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            firstHStackHeight = geometry.size.height
                        }
                }
            )
            .onTapGesture {
                withAnimation(.easeInOut) {
                    currencyToggle.toggle()
                    animateToggle = true
                    self.animateHeight = self.firstHStackHeight
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    withAnimation(.easeInOut) {
                        animateToggle = false
                    }
                }
            }
            
            HStack {
                Image("wallet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: firstHStackHeight*0.45, height: firstHStackHeight*0.45)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(height: firstHStackHeight)
            .background {
                RoundedCorners(color: .brightGreen.opacity(0.95), tr: 6, br: currencyToggle ? 0 : 6)
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: self.currencyToggle) {
                        mainHStackWidth = geometry.size.width
                    }
            }
        )
        .overlay() {
            currencyChange
                .frame(height: self.currencyToggle ? self.animateHeight+8-1+10 : 0)
                .offset(y: self.currencyToggle ? self.firstHStackHeight+8-1+10 : self.firstHStackHeight+15)
                .opacity(self.currencyToggle ? 1 : 0)
        }
    }
    
    @ViewBuilder
    private var currencyChange: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("\(String(format: "%.2f", accountModel.isLoggedIn ? self.accountModel.account.gambitCoin : 0))")
                    .font(.headline.weight(.bold))
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "guaranisign")
                        .bold()
                        .imageScale(.small)
                        .foregroundStyle(.yellow)
                    
//                    Text("Coin")
//                        .font(.subheadline)
//                        .italic()
                }
            }
            .onTapGesture {
                self.accountModel.account.setCurrency = .gambitCoin
                self.liveGameBalance = self.accountModel.account.activeCur
                
                withAnimation(.easeInOut) {
                    currencyToggle.toggle()
                }
            }
            .background {
                if self.accountModel.account.setCurrency == .gambitCoin {
                    RoundedCorners(color: .gray.opacity(0.3))
                        .frame(width: self.mainHStackWidth, height: self.firstHStackHeight/1.35)
                }
            }
            
            HStack(spacing: 2) {
                Text("\(String(format: "%.2f", accountModel.isLoggedIn ? self.accountModel.account.gambitCash : 0))")
                    .font(.headline.weight(.bold))
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 1) {
                    Image(systemName: "guaranisign")
                        .bold()
                        .imageScale(.small)
                        .foregroundStyle(.brightGreen)
                    
//                    Text("Cash")
//                        .font(.subheadline)
//                        .italic()
                }
            }
            .onTapGesture {
                self.accountModel.account.setCurrency = .gambitCash
                self.liveGameBalance = self.accountModel.account.activeCur

                withAnimation(.easeInOut) {
                    currencyToggle.toggle()
                }
            }
            .background {
                if self.accountModel.account.setCurrency == .gambitCash {
                    RoundedCorners(color: .gray.opacity(0.3))
                        .frame(width: self.mainHStackWidth, height: self.firstHStackHeight/1.35)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .frame(width: self.mainHStackWidth)
        .background {
            RoundedCorners(color: .duskGreen, bl: 6, br: 6)
        }
    }
}
