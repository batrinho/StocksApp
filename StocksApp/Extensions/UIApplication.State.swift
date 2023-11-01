//
//  UIApplication.State.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.11.2023.
//

import UIKit

extension UIApplication.State {
    var stringValue: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .background:
            return "background"
        @unknown default:
            fatalError()
        }
    }
}
