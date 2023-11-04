//
//  Int.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 02.11.2023.
//

import UIKit

extension Int {
    func getCellBackgroundColor () -> UIColor {
        return (self % 2 == 0) ? StockData.cellBackgroundColor : .clear
    }
}
