//
//  StockDataManager.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 05.08.2023.
//

import UIKit

final class StockDataManager {
    enum Constants {
        static let baseUrlString = "https://finnhub.io/api/v1/quote"
        static let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
    }
    
    func fetchPrice (stockTicker: String, completion: @escaping (StockPriceModel?) -> Void) {
        Task {
            do {
                guard let fetchedPrice = try await parseJSON(stockTicker: stockTicker) else { return }
                completion(fetchedPrice)
            } catch {
                completion(nil)
            }
        }
    }
    
    func parseJSON (stockTicker: String) async throws -> StockPriceModel? {
        let queryParameters = [
            "symbol": stockTicker,
            "token": Constants.apikey
        ]
        
        var urlComponents = URLComponents(string: Constants.baseUrlString)
        urlComponents?.queryItems = queryParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let theUrl = urlComponents?.url else { return nil }
        print(theUrl)
        let decoder = JSONDecoder()
        
        let (data, _) = try await URLSession.shared.data(from: theUrl)
        let decodedData = try decoder.decode(StockPriceModel.self, from: data)
        return decodedData
    }
}
