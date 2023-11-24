//
//  Data.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

struct Stock: Equatable {
    let name: String
    let ticker: String
    let logoUrl: String
    let logo: UIImage
    var favoriteButtonImage: UIImage
    let currentPrice: Double
    let changePrice: Double
}

struct StockModel: Codable, Equatable {
    let name: String
    let logo: String
    let ticker: String
}

struct StockPriceModel: Codable {
    let c: Double
    let d: Double
}

