//
//  vipView.swift
//  gambit
//
//  Created by Nick Mantini on 11/28/24.
//

import SwiftUI
import AlertToast

struct vipView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @ObservedObject var betModel: BetModel
    
    @State private var vipCategory: VipCategory = .progress
    @State private var currentDate = Date()
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            headerView(accountModel: self.accountModel)
                .environmentObject(alertViewModel)
                .padding(.horizontal, 17)
            
            ScrollView(showsIndicators: false) {
                vipProfile
                    .padding(.bottom, 7)
                
                CustomDropView(viewList: self.vipDesc, symbolName: "crown", title: "Benefits")
                    .padding(.bottom, 7)
                
                reload
                    .padding(.bottom, 7)
                    .onAppear(perform: startTimer)
                    .onDisappear(perform: stopTimer)
                
            }
            .padding(.horizontal, 17)
            
            Spacer()
        }
        .background {
            backgroundView()
        }
    }
    
    @ViewBuilder private var vipProfile: some View {
        VStack {
            HStack {
                Text(accountModel.isLoggedIn ? accountModel.account.username : "please login")
                    .font(.title2.weight(.bold))
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundStyle(self.accountModel.account.vip.vipLevel.color)
                    .imageScale(.large)
            }
            .padding(.bottom, 15)
            
            VStack {
                HStack(alignment: .top) {
                    Text("Your VIP Progress")
                    Spacer()
                    Text("\(String(format: "%.0f", self.accountModel.account.vip.vipProgress * 100))%")
                }
                
                LinearProgressView(value: self.accountModel.account.vip.vipProgress, shape: RoundedRectangle(cornerRadius: 6))
                    .tint(LinearGradient(colors: [.green, .softMint], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 16)
                
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "star")
                            .foregroundStyle(self.accountModel.account.vip.vipLevel.color)
                        Text("\(self.accountModel.account.vip.vipLevel.displayName)")
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 3) {
                        Image(systemName: "star")
                            .foregroundStyle(self.accountModel.account.vip.vipLevel.nextLevelColor)
                        Text("\(self.accountModel.account.vip.vipLevel.nextLevel)")
                    }
                }
                .foregroundStyle(.gray)
            }
            .font(.headline)
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.deepCharcoal)
                .stroke(.duskGreen, lineWidth: 3)
        }
        .padding([.horizontal, .vertical], 2)
        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.3), radius: 8, x: 0, y: 2)
    }
    
    @ViewBuilder private var reload: some View {
        VStack {
            HStack {
                Text("Reload")
                    .font(.title2.weight(.bold))
                
                Spacer()
                
                Image(systemName: "dollarsign.arrow.circlepath")
                    .imageScale(.large)
            }
            .padding(.bottom, 15)
            
            VStack {
                let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self.currentDate, to: self.accountModel.account.vip.reloadClaimedDate)
                
                if let days = components.day,
                   let hours = components.hour,
                   let minutes = components.minute,
                   let seconds = components.second {
                    
                    Text(self.accountModel.account.vip.isReloadReady ? "Ready!" :"Next reload")
                    
                    HStack {
                        VStack {
                            Text(String(days > 0 ? days : 0))
                                .font(.title3.bold())
                            
                            Text("\(days == 1 ? "day" : "days")")           .font(.headline.weight(.regular))
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.evenLighterBlack)
                        }
                        
                        VStack {
                            Text(String(hours > 0 ? hours : 0))
                                .font(.title3.bold())
                            
                            Text("\(days == 1 ? "hour" : "hours")")           .font(.headline.weight(.regular))
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.evenLighterBlack)
                        }
                        
                        VStack {
                            Text(String(minutes > 0 ? minutes : 0))
                                .font(.title3.bold())
                            
                            Text("min")
                                .font(.headline.weight(.regular))
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.evenLighterBlack)
                        }
                        
                        VStack {
                            Text(String(seconds > 0 ? seconds : 0))
                                .font(.title3.bold())
                            
                            Text("sec")
                                .font(.headline.weight(.regular))
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.evenLighterBlack)
                        }
                    }
                }
            }
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Amount:")
                    .font(.headline.weight(.bold))
                
                HStack {
                    HStack {
                        HStack {
                            Text("$ "+String(format: "%0.f", self.accountModel.account.vip.reloadAmount*100))
                            Spacer()
                            Image(systemName: "guaranisign")
                                .font(.title3.weight(.medium))
                                .foregroundStyle(.yellow)
                        }
                        .font(.title3.weight(.regular))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.all, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.duskGreen)
                                .stroke(.brightGreen, lineWidth: 1)
                        }
                        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        HStack {
                            Text("$ "+String(format: "%0.f",self.accountModel.account.vip.reloadAmount))
                            Spacer()
                            Image(systemName: "guaranisign")
                                .font(.title3.weight(.medium))
                                .foregroundStyle(.brightGreen)
                        }
                        .font(.title3.weight(.regular))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.all, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.duskGreen)
                                .stroke(.brightGreen, lineWidth: 1)
                        }
                        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Text("Claim")
                        .opacity(self.accountModel.account.vip.isReloadReady ? 1 : 0.4)
                        .disabled(!self.accountModel.account.vip.isReloadReady)
                        .font(.title3.bold())
                        .padding(.all, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(.brightGreen)
                                .opacity(self.accountModel.account.vip.isReloadReady ? 1 : 0.4)
                        }
                        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.3), radius: 8, x: 0, y: 4)
                        .onTapGesture {
                            self.accountModel.claimReload() { error in
                                if let (_, errorMsg) = error {
                                    alertViewModel.presentToast(
                                        toast: AlertToast(displayMode: .hud, type: .error(.red), title: errorMsg)
                                    )
                                }
                            }
                        }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.deepCharcoal)
                .stroke(.duskGreen, lineWidth: 3)
        }
        .padding([.horizontal, .vertical], 2)
        .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.3), radius: 8, x: 0, y: 4)
        
    }
    
    let vipDesc: [CustomDropViewModel] = [
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.bronze.displayName,
            color: AccountSchema.VIPLevels.bronze.color,
            bulletContent: [
                "Bonus from Support",
                "Rakeback enabled",
                "Weekly bonuses",
                "Monthly bonuses",
                "VIP Telegram channel access"
            ]
        ),
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.silver.displayName,
            color: AccountSchema.VIPLevels.silver.color,
            bulletContent: [
                "Bonus from Support",
                "Weekly & monthly bonuses increased"
            ]
        ),
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.gold.displayName,
            color: AccountSchema.VIPLevels.gold.color,
            bulletContent: [
                "Bonus from Support",
                "Weekly & monthly bonuses increased"
            ]
        ),
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.platinum.displayName,
            color: AccountSchema.VIPLevels.platinum.color,
            bulletContent: [
                "Bonus from Support",
                "Weekly & monthly bonuses increased",
                "14 - 42 Day, Daily bonus (Reload)"
            ]
        ),
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.diamond.displayName,
            color: AccountSchema.VIPLevels.diamond.color,
            bulletContent: [
                "Dedicated VIP host",
                "Bonus from VIP host",
                "Weekly & monthly bonuses increased",
                "Monthly bonuses"
            ]
        ),
        CustomDropViewModel(
            iconName: "star.fill",
            title: AccountSchema.VIPLevels.obsidian.displayName,
            color: AccountSchema.VIPLevels.obsidian.color,
            bulletContent: [
                "Bonus from VIP host",
                "Exclusively customized benefits",
                "Weekly & monthly bonuses increased",
                "Monthly bonuses"
            ]
        )
    ]
    
    private func startTimer() {
        stopTimer() // Stop any existing timer before starting a new one
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentDate = Date()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

enum VipCategory: String, CaseIterable, Identifiable {
    case progress = "Progress"
    case boost = "Boost"
    case rakeback = "Rakeback"
    var id: VipCategory { self }
}
