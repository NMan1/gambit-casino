//
//  accountModel.swift
//  node
//
//  Created by Nick Mantini on 10/30/24.
//

import Foundation
import SwiftUICore

struct AccountSchema: Codable {
    var _id: String = ""
    var appleId: String = ""
    var username: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var gambitCoin: Double = 0.0
    var gambitCash: Double = 0.0
    var createdAt: Date = Date()
    var isVerified: Bool = false
    var clientSeed: String = ""
    var hashedServerSeed: String = ""
    var bets: [Bet] = []
    var vip: Vip = Vip()
    
    var setCurrency: Currency = .gambitCash
    var activeGame: String = ""
    
    var activeCur: Double {
        get {
            if self.setCurrency == .gambitCoin {
                return self.gambitCoin
            }
            else {
                return self.gambitCash
            }
        }
        set(newValue) {
            if self.setCurrency == .gambitCoin {
                self.gambitCoin = newValue
            }
            else {
                self.gambitCash = newValue
            }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.appleId = try container.decodeIfPresent(String.self, forKey: .appleId) ?? ""
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        self.gambitCoin = try container.decodeIfPresent(Double.self, forKey: .gambitCoin) ?? 0.0
        self.gambitCash = try container.decodeIfPresent(Double.self, forKey: .gambitCash) ?? 0.0
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            self.createdAt = Date.fromISOString(createdAtString) ?? Date()
        } else {
            self.createdAt = Date()
        }
        
        self.isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified) ?? false
        self.clientSeed = try container.decodeIfPresent(String.self, forKey: .clientSeed) ?? ""
        self.hashedServerSeed = try container.decodeIfPresent(String.self, forKey: .hashedServerSeed) ?? ""
        self.bets = try container.decodeIfPresent([Bet].self, forKey: .bets) ?? []
        self.vip = try container.decodeIfPresent(Vip.self, forKey: .vip) ?? Vip()
    }
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case _id
        case appleId
        case username
        case email
        case phoneNumber
        case gambitCoin
        case gambitCash
        case createdAt
        case isVerified
        case clientSeed
        case hashedServerSeed
        case bets
        case vip
    }
    
    enum VIPLevels: Int, Codable {
        case none = 0
        case bronze
        case silver
        case gold
        case platinum
        case diamond
        case obsidian

        var displayName: String {
            switch self {
            case .none: return "None"
            case .bronze: return "Bronze"
            case .silver: return "Silver"
            case .gold: return "Gold"
            case .platinum: return "Platinum"
            case .diamond: return "Diamond"
            case .obsidian: return "Obsidian"
            }
        }
        
        var nextLevel: String {
            if let next = VIPLevels(rawValue: self.rawValue + 1) {
                switch next {
                case .none: return "None"
                case .bronze: return "Bronze"
                case .silver: return "Silver"
                case .gold: return "Gold"
                case .platinum: return "Platinum"
                case .diamond: return "Diamond"
                case .obsidian: return "Obsidian"
                }
            } else {
                return "Max"
            }
        }
        
        var color: Color {
            switch self {
            case .none: return .gray.opacity(0.6)
            case .bronze: return Color(red: 205/255, green: 127/255, blue: 50/255)
            case .silver: return Color(red: 157/255, green: 183/255, blue: 191/255)
            case .gold: return .yellow
            case .platinum: return Color(red: 129/255, green: 217/255, blue: 221/255)
            case .diamond: return Color(red: 0/255, green: 134/255, blue: 223/255)
            case .obsidian: return Color(red: 91/255, green: 73/255, blue: 101/255)
            }
        }
        
        var nextLevelColor: Color {
            if let next = VIPLevels(rawValue: self.rawValue + 1) {
                switch next {
                case .none: return .gray.opacity(0.6)
                case .bronze: return Color(red: 205/255, green: 127/255, blue: 50/255)
                case .silver: return Color(red: 157/255, green: 183/255, blue: 191/255)
                case .gold: return .yellow
                case .platinum: return Color(red: 129/255, green: 217/255, blue: 221/255)
                case .diamond: return Color(red: 0/255, green: 134/255, blue: 223/255)
                case .obsidian: return Color(red: 91/255, green: 73/255, blue: 101/255)
                }
            } else {
                return .gray
            }
        }
    }
    
    struct Vip: Codable {
        var vipLevel: VIPLevels = .none
        var vipProgress: Double = 0.0
        var reloadAmount: Double = 0.0
        var reloadClaimPeriod: Int = 24
        var reloadClaimedDate: Date = Date()
        
        var isReloadReady: Bool {
            let currentDate = Date()
            let elapsedTime = currentDate.timeIntervalSince(reloadClaimedDate)
            let reloadClaimPeriodInSeconds = Double(reloadClaimPeriod) * 3600
            return elapsedTime >= reloadClaimPeriodInSeconds
        }
        
        init() {
            // Default initializer
            let currentDate = Date()
            self.reloadClaimedDate = Calendar.current.date(byAdding: .hour, value: -reloadClaimPeriod, to: currentDate) ?? currentDate
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.vipLevel = try container.decodeIfPresent(VIPLevels.self, forKey: .vipLevel) ?? .none
            self.vipProgress = try container.decodeIfPresent(Double.self, forKey: .vipProgress) ?? 0.0
            self.reloadAmount = try container.decodeIfPresent(Double.self, forKey: .reloadAmount) ?? 0.0
            self.reloadClaimPeriod = try container.decodeIfPresent(Int.self, forKey: .reloadClaimPeriod) ?? 24

            if let claimedDateString = try container.decodeIfPresent(String.self, forKey: .reloadClaimedDate) {
                self.reloadClaimedDate = Date.fromISOString(claimedDateString) ?? Date()
            } else {
                self.reloadClaimedDate = Date()
            }
        }

        private enum CodingKeys: String, CodingKey {
            case vipLevel, vipProgress, reloadAmount, reloadClaimPeriod, reloadClaimedDate
        }
    }
    
    struct Bet: Codable {
        var currency: AccountSchema.Currency
        var gameId: String
        var betId: String
        var newBalance: Double
        var betAmount: Double
        var betResult: Double
        var multi: Double
    }
    
    enum Currency: String, Codable {
        case gambitCoin = "gambitCoin"
        case gambitCash = "gambitCash"
    }
}
