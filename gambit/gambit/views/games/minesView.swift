//
//  crashView.swift
//  gambit
//
//  Created by Nick Mantini on 11/20/24.
//

import SwiftUI

struct minesView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @ObservedObject var accountModel: AccountModel
    @ObservedObject var betModel: BetModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
