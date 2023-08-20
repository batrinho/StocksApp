//
//  StockDataManager.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 05.08.2023.
//

import UIKit

protocol StockDataManagerProtocol {
    func fetchPrice (stockSymbol: String, completion: @escaping (StockPriceData?) -> Void)
}

final class StockDataManager: StockDataManagerProtocol {
    func fetchPrice (stockSymbol: String, completion: @escaping (StockPriceData?) -> Void) {
        if let price = StockData.prices[stockSymbol] {
            completion(price)
        } else {
            Task {
                do {
                    guard let fetchedPrice = try await parseJSON(stockSymbol: stockSymbol) else { return }
                    StockData.prices[stockSymbol] = fetchedPrice
                    completion(fetchedPrice)
                } catch {
                    completion(nil)
                }
            }
        }
    }
    
    func parseJSON (stockSymbol: String) async throws -> StockPriceData? {
        do {
            let queryParameters = [
                "symbol": stockSymbol,
                "token": StockData.apikey
            ]
            
            var urlComponents = URLComponents(string: StockData.baseUrlString)
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
