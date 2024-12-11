//
//  ContentView.swift
//  node
//
//  Created by Nick Mantini on 10/28/24.
//

import SwiftUI
import AlertToast
import SwiftKeychainWrapper
import SVGView

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var alertViewModel: AlertViewModel
    @StateObject private var accountModel = AccountModel()
    @StateObject private var betModel: BetModel
    @State private var liveGameBalance: Double = 1.0

    init() {
        let accountModel = AccountModel()
        _accountModel = StateObject(wrappedValue: accountModel)
        _betModel = StateObject(wrappedValue: BetModel(accountModel: accountModel))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case .home:
                        homeView(accountModel: self.accountModel, betModel: self.betModel, liveGameBalance: self.$liveGameBalance)
                            .environmentObject(alertViewModel)
                    case .vip:
                        vipView(accountModel: self.accountModel, betModel: self.betModel)
                            .environmentObject(alertViewModel)
                    case .bets:
                        Text("Bets View")
                            .foregroundColor(.white)
                    case .chat:
                        Text("Chat View")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("deepBlack").edgesIgnoringSafeArea(.all))
                
                navbarView(selectedTab: $selectedTab)
            }
        }
        .overlay(alignment: .top) {
            if !self.accountModel.account.activeGame.isEmpty {
                walletDisplayView(accountModel: self.accountModel, liveGameBalance: Binding<Double?>(
                    get: { self.liveGameBalance }, // Convert Double to Double?
                    set: { self.liveGameBalance = $0 ?? 0 } // Convert Double? back to Double with a fallback
                ))
            }
        }
        .toast(isPresenting: $alertViewModel.show, duration: 2, offsetY: 11) {
            alertViewModel.alertToast
        }
        .tint(.white)
        .onAppear {
            if (!self.accountModel.isLoggedIn) {
                let appleId: String? = KeychainWrapper.standard.string(forKey: "appleId")
                let password: String? = KeychainWrapper.standard.string(forKey: "password")
                let phoneNumber: String? = KeychainWrapper.standard.string(forKey: "phoneNumber")
                
                if (appleId != nil && !appleId!.isEmpty) {
                    accountModel.appleAuthenticationLogin(appleId: appleId!, completion: { error in
                        
                    })
                }
                else if (password != nil && phoneNumber != nil) {
                    accountModel.phoneAuthenticaionLogin(phoneNumber: phoneNumber!, password: password!, completion: { error in
                        
                    })
                }
            }
        }
    }
}

@ViewBuilder public var pleaseLogin: some View {
    VStack {
        Spacer()
        Text("Please login first")
            .italic()
        Spacer()
    }
}

class AlertViewModel: ObservableObject {
    @Published var show = false
    @Published var alertToast = AlertToast(displayMode: .hud, type: .regular, title: "SOME TITLE")

    func presentToast(toast: AlertToast) {
        DispatchQueue.main.async {
            self.alertToast = toast
            self.show = true
        }

        // Optionally reset `show` after the toast duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.show = false
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AlertViewModel())
}
