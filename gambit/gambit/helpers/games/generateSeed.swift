//
//  generateSeed.swift
//  gambit
//
//  Created by Nick Mantini on 11/23/24.
//

import Foundation
import CryptoKit

func generateRandomClientSeed() -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<32).map { _ in characters.randomElement()! })
}

func generateClientSeedWithInputData(input: String) -> String {
    let randomPart = generateRandomClientSeed()
    let combined = input + randomPart
    let hash = SHA256.hash(data: combined.data(using: .utf8)!)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}
