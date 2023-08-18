//
//  CoreDatabaseManager.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 16.08.2023.
//

import UIKit
import CoreData

protocol CoreDatabaseManagerProtocol {
    func addStock (stock: StockProfileData)
    func deleteStock (stock: StockProfileData)
    func getIsFavorite (ticker: String) -> Bool
}

protocol CoreDatabaseManagerFetchProtocol {
    func fetchStocks (completion: @escaping ([StockProfileData]?) -> Void)
}

class CoreDatabaseManager: CoreDatabaseManagerProtocol, CoreDatabaseManagerFetchProtocol {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var favoriteStocks: [FavoriteStock]?
    
    func addStock (stock: StockProfileData) {
        let newStock = FavoriteStock(context: self.context)
        newStock.logo = stock.logo
        newStock.ticker = stock.ticker
        newStock.name = stock.name
        
        do {
            try context.save()
        } catch {
            print("lol")
        }
        
        fetchStocks { stockProfileDataArray in
            if let newArray = stockProfileDataArray {
                DispatchQueue.main.async {
                    StockData.favoritesStockCompanies = newArray
                }
            }
        }
    }
    
    func deleteStock (stock: StockProfileData) {
        let fetchRequest: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@", stock.ticker)
        
        do {
            let matchingStocks = try context.fetch(fetchRequest)
            for matchingStock in matchingStocks {
                context.delete(matchingStock)
                try context.save()
            }
            
            fetchStocks { stockProfileDataArray in
                if let newArray = stockProfileDataArray {
                    DispatchQueue.main.async {
                        StockData.favoritesStockCompanies = newArray
                    }
                }
            }
            
        } catch {
            print("Error deleting stock: \(error)")
        }
    }
    
    
    func fetchStocks (completion: @escaping ([StockProfileData]?) -> Void) {
        var resultingArray = [StockProfileData]()
        
        do {
            self.favoriteStocks = try self.context.fetch(FavoriteStock.fetchRequest())
        } catch {
            print("rofl")
        }
        
        for favoriteStock in favoriteStocks! {
            var theLogo = ""
            if let logo = favoriteStock.logo {
                theLogo = logo
            }
            let stockProfileData = StockProfileData(name: favoriteStock.name!, logo: theLogo, ticker: favoriteStock.ticker!)
            resultingArray.append(stockProfileData)
        }
        
        completion(resultingArray)
    }
    
    func getIsFavorite (ticker: String) -> Bool  {
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
