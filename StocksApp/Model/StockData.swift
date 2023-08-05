//
//  Data.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

struct StockData {
    static let stocksCellIndentifier = "stocksCell"
    static let localJsonFile = "stockProfiles"
    static let baseUrlString = "https://finnhub.io/api/v1/quote"
    static let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
    static var stockCompanies = [StockProfileData]()
    static var usedLogos: [String: UIImage] = [:]
    static var favorites: [String: Bool] = [:]
    static var prices: [String: StockPriceData] = [:]
}

struct StockProfileData: Codable {
    let name: String
    let logo: String
    let ticker: String
}

struct StockPriceData: Codable {
    let c: Double
    let d: Double
}

struct StockProfile {
    let name: String
    let symbol: String
    let logo: UIImage
    let backgroundColor: UIColor
}

