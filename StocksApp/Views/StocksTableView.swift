//
//  StocksTableViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableView: UITableView {
    private let networkingService: NetworkingServiceProtocol = NetworkingService()
    private let stockDataManager: StockDataManagerProtocol = StockDataManager()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    private func setupTableView () {
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.delegate = self
        self.dataSource = self
        self.register(StocksTableViewCell.self, forCellReuseIdentifier: StockData.stocksCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        
        let buttonImage = StockData.favorites[stock.ticker] == true ? StockData.filledStar : StockData.emptyStar
        cell.setButtonImage(newImage: buttonImage)
        
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
