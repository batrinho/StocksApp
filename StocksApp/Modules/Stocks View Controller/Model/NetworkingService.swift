//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchStockLogo(from urlString: String) async throws -> UIImage?
    func fetchPrice(stockTicker: String) async throws -> StockPriceModel?
    func stockDataFromLocalFile(with name: String) -> [StockModel]
}

final class NetworkingService: NetworkingServiceProtocol {
    enum Constants {
        static let baseUrlString = "https://finnhub.io/api/v1/quote"
        static let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
    }

    func fetchStockLogo(from urlString: String) async throws -> UIImage? {
        guard let imageUrl = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            return UIImage(data: data)
        } catch {
            throw error
        }
    }

    func fetchPrice(stockTicker: String) async throws -> StockPriceModel? {
        do {
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

            let (data, _) = try await URLSession.shared.data(from: theUrl)
            let decoder = JSONDecoder()
            return try decoder.decode(StockPriceModel.self, from: data)
        } catch {
            throw error
        }
    }

    func stockDataFromLocalFile(with name: String) -> [StockModel] {
        do {
            guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }

            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            return try decoder.decode([StockModel].self, from: data)
        } catch {
            print("Error getting data from local json file: \(error)")
            return []
        }
    }
}
