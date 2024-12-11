//
//  accountModel.swift
//  node
//
//  Created by Nick Mantini on 10/28/24.
//

import Foundation
import Request
import Json
import SwiftKeychainWrapper

@MainActor
class AccountModel: ObservableObject {
    @Published var account: AccountSchema = AccountSchema()
    
    var isLoggedIn: Bool {
        return self.account._id != ""
    }
    
    @MainActor
    func appleAuthenticationLogin(appleId: String, authToken: String="", fullName: String="", email: String="", completion: @escaping ((code: String, message: String)?) -> Void) {
        Request {
            Url(serverIp+"/appleAuth")
            Method(.post)
            Header.Accept(.json)
            Query(["authToken": authToken, "appleId": appleId, "fullName": fullName, "email": email])
        }
        .onData { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedAccount = try decoder.decode(AccountSchema.self, from: data)
                DispatchQueue.main.async {
                    self.account = decodedAccount
                    completion(nil)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(("DECODE_ERROR", "Network error, Try again later."))
                }
            }
        }
        .onError { error in
            if let requestError = error as? RequestError {
                let (errorCode, errorMsg) = getRequestError(requestError)
                completion((errorCode, errorMsg))
            }
            else {
                completion(("UNKOWN", "Network error, Try again later."))
            }
        }
        .call()
    }
    
    @MainActor
    func phoneAuthenticaionLogin(
        phoneNumber: String,
        password: String,
        username: String = "",
        completion: @escaping ((code: String, message: String)?) -> Void
    ) {
        var strippedPhone = phoneNumber
        strippedPhone.replace("-", with: "")
        strippedPhone.replace("(", with: "")
        strippedPhone.replace(")", with: "")
        strippedPhone.replace(" ", with: "")
        
        let parameters = [
            "phoneNumber": strippedPhone,
            "password": password,
            "username": username,
        ]

        Request {
            Url(serverIp + "/phoneAuth")
            Method(.post)
            Header.Accept(.json)
            Header.ContentType(.json)
            Body(parameters)
        }
        .onData { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedAccount = try decoder.decode(AccountSchema.self, from: data)
                DispatchQueue.main.async {
                    self.account = decodedAccount
                    completion(nil)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(("DECODE_ERROR", "Network error, Try again later."))
                }
            }
        }
        .onError { error in
            if let requestError = error as? RequestError {
                let (errorCode, errorMsg) = getRequestError(requestError)
                completion((errorCode, errorMsg))
            }
            else {
                completion(("UNKOWN", "Network error, Try again later."))
            }
        }
        .call()
    }

    @MainActor
    func setClientSeed(
        clientSeed: String,
        completion: @escaping ((code: String, message: String)?) -> Void
    ) {
        let parameters = [
            "userId": self.account._id,
            "clientSeed": clientSeed,
        ]

        Request {
            Url(serverIp + "/setClientSeed")
            Method(.post)
            Header.Accept(.json)
            Header.ContentType(.json)
            Body(parameters)
        }
        .onData { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedAccount = try decoder.decode(AccountSchema.self, from: data)
                DispatchQueue.main.async {
                    self.account = decodedAccount
                    completion(nil)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(("DECODE_ERROR", "Network error, Try again later."))
                }
            }
        }
        .onError { error in
            if let requestError = error as? RequestError {
                let (errorCode, errorMsg) = getRequestError(requestError)
                completion((errorCode, errorMsg))
            }
            else {
                completion(("UNKOWN", "Network error, Try again later."))
            }
        }
        .call()
    }
    
    @MainActor
    func claimReload(
        completion: @escaping ((code: String, message: String)?) -> Void
    ) {
        let parameters = [
            "userId": self.account._id,
        ]

        Request {
            Url(serverIp + "/claimReload")
            Method(.post)
            Header.Accept(.json)
            Header.ContentType(.json)
            Body(parameters)
        }
        .onData { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedAccount = try decoder.decode(AccountSchema.self, from: data)
                DispatchQueue.main.async {
                    self.account = decodedAccount
                    completion(nil)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion(("DECODE_ERROR", "Network error, Try again later."))
                }
            }
        }
        .onError { error in
            if let requestError = error as? RequestError {
                let (errorCode, errorMsg) = getRequestError(requestError)
                completion((errorCode, errorMsg))
            }
            else {
                completion(("UNKOWN", "Network error, Try again later."))
            }
        }
        .call()
    }
    
    @MainActor
    func logOut() {
        self.account = AccountSchema()
        
        KeychainWrapper.standard.remove(forKey: "appleId")
        KeychainWrapper.standard.remove(forKey: "password")
        KeychainWrapper.standard.remove(forKey: "phoneNumber")
    }
}
