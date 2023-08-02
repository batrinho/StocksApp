//
//  Data.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

struct StockData {
    let stocksCellIndentifier = "stocksCell"
    static var companies = [StockProfileData]()
}

struct StockProfileData: Codable {
    let name: String
    let logo: String
    let ticker: String
}

