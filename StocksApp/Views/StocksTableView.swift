//
//  StocksTableViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableView: UITableView {
<<<<<<< HEAD
    var isStocks = true
=======
    private let networkingService: NetworkingServiceProtocol = NetworkingService()
    private let stockDataManager: StockDataManagerProtocol = StockDataManager()
    weak var coreDatabaseManager: CoreDataDatabaseManager?
>>>>>>> a3a4c03cd9b98dd79e4cd58982705730b17d83b1
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    private func setupTableView () {
        separatorStyle = UITableViewCell.SeparatorStyle.none
        showsVerticalScrollIndicator = false
        register(StocksTableViewCell.self, forCellReuseIdentifier: StockData.stocksCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
<<<<<<< HEAD
=======

// MARK: - Delegate, DataSource

extension StocksTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockData.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockData.stocksCellIndentifier, for: indexPath) as? StocksTableViewCell else {
            return UITableViewCell()
        }
        
        let stock = StockData.companies[indexPath.row]
        let cellBackground = indexPath.row % 2 == 0 ? StockData.cellBackgroundColor : .systemBackground
        cell.updateLabels(newCompanySymbol: stock.ticker, newCompanyTitle: stock.name, cellBackgroundColor: cellBackground, logo: stock.logo)

        let isFavorite = coreDatabaseManager!.getIsFavorite(ticker: stock.ticker)
        cell.configure(isFavourite: isFavorite) { currentState in
            print(indexPath.row, currentState)
        }
        
        networkingService.fetchCompanyLogo(logoUrl: stock.logo) { image in
            DispatchQueue.main.async {
                if let newImage = image {
                    cell.updateLogo(newCompanyLogo: newImage)
                }
            }
        }
        
        stockDataManager.fetchPrice(stockSymbol: stock.ticker) { price in
            DispatchQueue.main.async {
                if let newPrice = StockData.prices[stock.ticker] {
                    cell.updatePrices(currentPrice: newPrice.c, priceChange: newPrice.d)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
>>>>>>> a3a4c03cd9b98dd79e4cd58982705730b17d83b1
