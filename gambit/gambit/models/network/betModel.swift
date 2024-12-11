//
//  bets.swift
//  gambit
//
//  Created by Nick Mantini on 11/23/24.
//

import Foundation
import Request
import Json
import SwiftKeychainWrapper
import SwiftUICore

@MainActor
class BetModel: AccountModel {
    private let accountModel: AccountModel
    
    init(accountModel: AccountModel) {
        self.accountModel = accountModel
    }
    
    @MainActor
    func processBet(
        gameId: String,
        activeCur: AccountSchema.Currency,
        betAmmount: Double,
        completion: @escaping ((code: String, message: String)?, AccountSchema.Bet?) -> Void
    ) {
        let parameters = [
            "userId": self.accountModel.account._id,
            "currency": activeCur.rawValue,
            "gameId": gameId,
            "betAmmount": betAmmount,
        ] as [String : Any]
        
        Request {
            Url(serverIp + "/processBet")
            Method(.post)
            Header.Accept(.json)
            Header.ContentType(.json)
            Body(parameters)
        }
        .onData { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedBet = try decoder.decode(AccountSchema.Bet.self, from: data)
                DispatchQueue.main.async {
                    self.accountModel.account.setCurrency = decodedBet.currency
                    self.accountModel.account.activeCur = decodedBet.newBalance
                    self.accountModel.account.bets.append(decodedBet)
                    completion(nil, decodedBet)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(("DECODE_ERROR", "Network error, Try again later."), nil)
                }
            }
        }
        .onError { error in
            if let requestError = error as? RequestError {
                let (errorCode, errorMsg) = getRequestError(requestError)
                completion((errorCode, errorMsg), nil)
            }
            else {
                completion(("UNKOWN", "Network error, Try again later."), nil)
            }
        }
        .call()
    }
}
