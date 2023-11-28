//
//  CoreDatabaseManager.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 16.08.2023.
//

import UIKit
import CoreData

protocol CoreDataDatabaseManagerProtocol {
    func addStock(stock: StockModel)
    func deleteStock(stock: StockModel)
    func fetchFavoriteStocks() -> [StockModel]?
    func getIsFavorite(ticker: String) -> Bool
    func addRequest(request: String)
    func fetchRecentRequests() -> [String]?
}

final class CoreDataDatabaseManager: CoreDataDatabaseManagerProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addStock(stock: StockModel) {
        let newStock = FavoriteStock(context: self.context)
        newStock.logo = stock.logo
        newStock.ticker = stock.ticker
        newStock.name = stock.name
        
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
    }
    
    func deleteStock(stock: StockModel) {
        let fetchRequest: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@", stock.ticker)
        
        do {
            let matchingStocks = try context.fetch(fetchRequest)
            for matchingStock in matchingStocks {
                context.delete(matchingStock)
            }
            try context.save()
        } catch {
            print("Error deleting stock: \(error)")
        }
        
    }
    
    func fetchFavoriteStocks() -> [StockModel]? {
        do {
            guard let favoriteStocks = try self.context.fetch(FavoriteStock.fetchRequest()) as? [FavoriteStock] else { return nil }
            var resultingArray: [StockModel] = []
            for favoriteStock in favoriteStocks {
                guard let stockName = favoriteStock.name,
                      let stockLogo = favoriteStock.logo,
                      let stockTicker = favoriteStock.ticker else { return nil }
                resultingArray.append(StockModel(name: stockName, logo: stockLogo, ticker: stockTicker))
            }
            return resultingArray
        } catch {
            print("Error fetching favorite stocks: \(error)")
            return nil
        }
    }
    
    func getIsFavorite(ticker: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)
        
        do {
            let matchingStocks = try context.fetch(fetchRequest)
            return !matchingStocks.isEmpty
        } catch {
            print("Error checking if stock exists: \(error)")
            return false
        }
    }
}

// MARK: - Recent Requests
extension CoreDataDatabaseManager {
    func addRequest(request: String) {
        if !request.isEmpty {
            let newRequest = RecentRequest(context: self.context)
            newRequest.requestTitle = request
            do {
                try context.save()
            } catch {
                print("Error adding request")
            }
        }
    }
    
    func fetchRecentRequests() -> [String]? {
        do {
            let recentRequests = try self.context.fetch(RecentRequest.fetchRequest()) as? [RecentRequest]
            return recentRequests?.compactMap { recentRequest in
                guard let request = recentRequest.requestTitle else { return nil }
                return request
            }
        } catch {
            print("Error fetching recent requests")
            return nil
        }
    }
}
