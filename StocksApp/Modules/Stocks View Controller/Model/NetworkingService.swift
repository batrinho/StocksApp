//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchStockInformation(with stockModel: StockModel, isFavorite: Bool) async throws -> Stock?
    func stockDataFromLocalFile(with name: String) -> [StockModel]
}

final class NetworkingService: NetworkingServiceProtocol {
    private let yellowStar = UIImage(named: "star.yellow.fill")
    private let grayStar = UIImage(named: "star.gray.fill")
    enum Constants {
        static let baseUrlString = "https://finnhub.io/api/v1/quote"
        static let apikey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
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
    
    func fetchStockInformation(with stockModel: StockModel, isFavorite: Bool) async throws -> Stock? {
        guard let stockLogo = try await fetchStockLogo(from: stockModel.logo) else {
            print("Error fetching logo for \(stockModel.ticker)")
            return nil
        }
        guard let stockPriceModel = try await fetchPrice(stockTicker: stockModel.ticker) else {
            print("Error fetching price for \(stockModel.ticker)")
            return nil
        }
        return Stock(
            name: stockModel.name,
            ticker: stockModel.ticker,
            logoUrl: stockModel.logo,
            logo: stockLogo,
            favoriteButtonImage: ((isFavorite ? self.yellowStar : self.grayStar)!),
            currentPrice: stockPriceModel.c,
            changePrice: stockPriceModel.d
        )
    }

    private func fetchStockLogo(from urlString: String) async throws -> UIImage? {
        guard let imageUrl = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            return UIImage(data: data)
        } catch {
            throw error
        }
    }

    private func fetchPrice(stockTicker: String) async throws -> StockPriceModel? {
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
            let (data, _) = try await URLSession.shared.data(from: theUrl)
            let decoder = JSONDecoder()
            return try decoder.decode(StockPriceModel.self, from: data)
        } catch {
            throw error
        }
    }
}
