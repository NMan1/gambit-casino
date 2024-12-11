//
//  accountView.swift
//  node
//
//  Created by Nick Mantini on 10/28/24.
//

import SwiftUI
import AlertToast
import AuthenticationServices
import SwiftKeychainWrapper

struct accountView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    
    var body: some View {
        VStack {
            header
            
            Divider()
            
            subscriptionMangament
            
            Divider()
                        
            Spacer()
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(spacing: 10) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text("Account")
                    .font(.largeTitle.weight(.medium))
            }
            
            Spacer()
            
            Text("Hi, \(accountModel.account.username)")
                .font(.title3.weight(.regular))
        }
    }
    
    @ViewBuilder private var subscriptionMangament: some View {
        VStack {
            HStack(alignment: .center) {
                HStack(spacing: 10) {
                    Text("Your subscription")
                        .font(.title2.weight(.medium))
                }
                
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Text("Pro status")
            }
        }
    }
}

