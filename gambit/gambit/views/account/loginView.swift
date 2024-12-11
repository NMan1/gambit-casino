//
//  loginView.swift
//  node
//
//  Created by Nick Mantini on 10/31/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import SwiftKeychainWrapper
import AlertToast

struct loginView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @State var loginType: LoginType
    @State var currentView: LoginViewType = .defaultView
    
    @State var userInput: String = "enter anything"
    @State var clientSeed: String = generateClientSeedWithInputData(input: "enter anything")
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack() {
            if self.currentView != .postSignUp {
                header
                
                Spacer()

                loginMethodsView(accountModel: self.accountModel, loginType: self.loginType, currentView: self.$currentView)
                    .environmentObject(self.alertViewModel)
                  
                Spacer()
                
                if self.currentView != .signUpWithPhone {
                    promoImage
                }
            }
            else {
                postSignUp
                    .navigationBarBackButtonHidden()
            }
        }
        .padding(.horizontal, 25)
        .background {
            backgroundView()
        }
        .edgesIgnoringSafeArea(self.currentView != .signUpWithPhone ? .bottom : .leading)
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(spacing: 0) {
            Text("Gambit")
                .foregroundStyle(.brightGreen)
                .font(.largeTitle.weight(.black))
            
            Text("Play Smart, Win Big.")
                .font(.title3.weight(.regular))
                .kerning(1)
        }
    }
    
    @ViewBuilder private var postSignUp: some View {
        VStack(spacing: 0) {
            Text("Gambit")
                .foregroundStyle(.brightGreen)
                .font(.largeTitle.weight(.black))
        }
        .padding(.top)
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 20) {
            Text("Hey, thanks for joining!")
                .font(.title.weight(.bold))
                .foregroundStyle(.brightGreen)

            Text("Before hopping into action, its important you know something about us...")
                .font(.title3.weight(.regular))

            (Text("Gambit operates under a ") + Text("provably fair gambling system").underline(true, color: .brightGreen).bold() + Text("."))
                .font(.title3.weight(.regular))

            Text("To ensure fairness, we offer the user the ability to randomize their own seed during registration.")
                .font(.title3.weight(.regular))

        }
        .lineLimit(nil)
        .truncationMode(.tail)
        .fixedSize(horizontal: false, vertical: true)

        Spacer()

        
        VStack(alignment: .leading) {
            Text("Set client seed")
                .font(.title.weight(.bold))
                .foregroundStyle(.brightGreen)

            TextField("user input", text: self.$userInput)
                .autocorrectionDisabled()
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.duskGreen, lineWidth: 2)
                )
                .onChange(of: self.userInput) {
                    self.clientSeed = generateClientSeedWithInputData(input: self.userInput)
                }
            
            Text(self.clientSeed)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
                .truncationMode(.tail)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.duskGreen, lineWidth: 2)
                )
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.accountModel.setClientSeed(clientSeed: self.clientSeed) { error in
                    if let (_, errorMsg) = error {
                        alertViewModel.presentToast(
                            toast: AlertToast(displayMode: .hud, type: .error(.red), title: errorMsg)
                        )
                    } else if self.accountModel.isLoggedIn {
                        dismiss()
                        
                        alertViewModel.presentToast(
                            toast: AlertToast(displayMode: .hud, type: .complete(.brightGreen), title: "Welcome")
                        )
                    }
                    else {
                        alertViewModel.presentToast(
                            toast: AlertToast(displayMode: .hud, type: .error(.red), title: "An unkown error occurred, try again later.")
                        )
                    }
                }
            }) {
                HStack {
                    Spacer()
                                        
                    Text("Confirm")
                        .font(.title3.bold())
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.brightGreen)
                }
            }
        }
                
        Spacer()
    }

    @ViewBuilder
    private var promoImage: some View {
        Image("ufcPromoLogo")
            .resizable()
            .scaledToFit()
    }
}

enum LoginType {
case SignUp
case SignIn
}
