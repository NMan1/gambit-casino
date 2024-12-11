//
//  AppDelegate.swift
//  barpass
//
//  Created by Nick Mantini on 9/5/24.
//

import Foundation
import Siren
import UIKit
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

        let siren = Siren.shared
        let rules = Rules(promptFrequency: .immediately, forAlertType: .force)
        siren.rulesManager = RulesManager(globalRules: rules)
        
        Siren.shared.wail()

        return true
        
    }
}

