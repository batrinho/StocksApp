//
//  StocksTableViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableView: UITableView {
    private let networkingService = NetworkingService()
    private let stockDataManager = StockDataManager()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.delegate = self
        self.dataSource = self
        self.register(StocksTableViewCell.self, forCellReuseIdentifier: StockData().stocksCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StocksTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockData.stockCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockData().stocksCellIndentifier, for: indexPath) as? StocksTableViewCell else {
            return UITableViewCell()
        }
        
        let newCell = StockData.stockCompanies[indexPath.row]
        cell.updateLabels(newCompanySymbol: newCell.ticker, newCompanyTitle: newCell.name, cellBackgroundColor: indexPath.row % 2 == 0 ? UIColor(red: 0.941176471, green: 0.956862745, blue: 0.968627451, alpha: 1): .systemBackground)
        
        if StockData.favorites[newCell.ticker] == true {
            cell.setImageButton(newImage: UIImage(named: "Image")!)
        } else {
            cell.setImageButton(newImage: UIImage(named: "Image-1")!)
        }
        
        if let newImage = StockData.usedLogos[newCell.logo] {
            cell.updateLogo(newCompanyLogo: newImage)
        } else {
            Task {
                do {
                    guard let imageUrl = URL(string: newCell.logo),
                          let fetchedImage = try await networkingService.fetchCompanyLogo(url: imageUrl) else { return }
                    DispatchQueue.main.async {
                        cell.updateLogo(newCompanyLogo: fetchedImage)
                        StockData.usedLogos[newCell.logo] = fetchedImage
                    }
                } catch {}
            }
        }
        
        if let newPrice = StockData.prices[newCell.ticker] {
            cell.updatePrices(currentPrice: newPrice.c, priceChange: newPrice.d)
        } else {
            Task {
                do {
                    guard let fetchedPrice = try await stockDataManager.fetchPrice(stockSymbol: newCell.ticker) else { return }
                    DispatchQueue.main.async {
                        cell.updatePrices(currentPrice: fetchedPrice.c, priceChange: fetchedPrice.d)
                        StockData.prices[newCell.ticker] = fetchedPrice
                    }
                } catch {}
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
