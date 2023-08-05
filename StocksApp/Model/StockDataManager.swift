//
//  StockDataManager.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 05.08.2023.
//

import UIKit

final class StockDataManager {
    func fetchPrice (stockSymbol: String) async throws -> StockPriceData? {
        do {
            let baseUrlString = "https://finnhub.io/api/v1/quote"
            let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
            let queryParameters = [
                "symbol": stockSymbol,
                "token": apikey
            ]
            
            var urlComponents = URLComponents(string: baseUrlString)
            urlComponents?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            guard let theUrl = urlComponents?.url else { return nil }
            
            print(theUrl)
            
            let decoder = JSONDecoder()
            
            let (data, _) = try await URLSession.shared.data(from: theUrl)
            let decodedData = try decoder.decode(StockPriceData.self, from: data)
            return decodedData
            
            
        } catch { return nil }
    }
}
