//
//  UIColor.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 02.11.2023.
//

import UIKit

extension UIColor {
    func getCellBackgroundColor (id: Int) -> UIColor {
        return (id % 2 == 0) ? StockData.cellBackgroundColor : .clear;
    }
}
