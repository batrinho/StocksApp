//
//  Data.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

struct StockData {
    let stocksCellIndentifier = "stocksCell"
    static var stockCompanies = [StockProfileData]()
    static var usedLogos: [String: UIImage] = [:]
}

struct StockProfileData: Codable {
    let name: String
    let logo: String
    let ticker: String
}

struct StockProfile {
    let name: String
    let symbol: String
    let logo: UIImage
    let backgroundColor: UIColor
}

