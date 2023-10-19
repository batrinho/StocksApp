//
//  Data.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

struct StockData {
    static let stocksCellIndentifier = "stocksCell"
    static let collectionViewCellIndentifier = "collectionViewCell"
    static let localJsonFile = "stockProfiles (1)"
    static let baseUrlString = "https://finnhub.io/api/v1/quote"
    static let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
    static let cellBackgroundColor = UIColor(red: 0.941176471, green: 0.956862745, blue: 0.968627451, alpha: 1)
    static let filledStar = UIImage(named: "star.yellow.fill")!
    static let emptyStar = UIImage(named: "star.gray.fill")!
    static let reusableImage = UIImage()
    
    static var companies = [StockProfileData]()
    static var stockCompanies = [StockProfileData]()
    static var favoritesStockCompanies = [StockProfileData]()
    static var tickers = [String]()
    
    static var logos: [String: UIImage] = [:]
    static var favorites: [String: Bool] = [:]
    static var prices: [String: StockPriceData] = [:]
    
    static let popularStocks = ["Apple","Amazon","Google","Tesla","Microsoft","Facebook","Alibaba","Yandex","Mastercard","Booking","Firstsolar"]
    static var recentRequests = [String]()
}

struct StockProfileData: Codable, Equatable {
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
