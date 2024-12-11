//
//  header.swift
//  gambit
//
//  Created by Nick Mantini on 11/29/24.
//

import SwiftUI

struct headerView: View {
    @ObservedObject var accountModel: AccountModel
    @EnvironmentObject var alertViewModel: AlertViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Gambit")
                    .font(.largeTitle.weight(.black))
                    .foregroundStyle(.brightGreen)

                Spacer()
                
                if accountModel.isLoggedIn {
                    walletDisplayView(accountModel: self.accountModel)
                }
                else {
                    loginTypeButtons
                }
            }
        }
        .zIndex(1)
    }
    
    @ViewBuilder
    private var loginTypeButtons: some View {
        HStack {
            NavigationLink(destination: loginView(accountModel: self.accountModel, loginType: .SignIn).environmentObject(alertViewModel)) {
                
                Text("Sign in")
                    .font(.headline.bold())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.clear)
                    }
            }
            .buttonStyle(.plain)
            
            NavigationLink(destination: loginView(accountModel: self.accountModel, loginType: .SignUp).environmentObject(alertViewModel)) {
                
                Text("Sign up")
                    .font(.headline.bold())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.duskGreen)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
