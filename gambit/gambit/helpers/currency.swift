//
//  currency.swift
//  gambit
//
//  Created by Nick Mantini on 12/4/24.
//

import Foundation

var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
}
