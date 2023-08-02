//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    let companyLogoView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 5
        
        return view
    } ()
    
    let companyLogo: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.layer.cornerRadius = 5
        image.backgroundColor = .white
        
        return image
    } ()
    
    let companyTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textColor = .black
        return title
    } ()
    
    let companySymbol: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textColor = .black
        return title
    } ()
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    } ()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    } ()
    
    // MARK: - Methods

    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StockData().stocksCellIndentifier)
        setupView()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView () {
        contentView.addSubview(cellStackView)
        
        companyLogoView.addSubview(companyLogo)
        NSLayoutConstraint.activate([
            companyLogo.centerXAnchor.constraint(equalTo: companyLogoView.centerXAnchor),
            companyLogo.centerYAnchor.constraint(equalTo: companyLogoView.centerYAnchor)
        ])
        
        cellStackView.addArrangedSubview(companyLogoView)
        cellStackView.addArrangedSubview(titleStackView)
        
        titleStackView.addArrangedSubview(companySymbol)
        titleStackView.addArrangedSubview(companyTitle)
    }
    
    func updateView (newCompanySymbol: String, newCompanyTitle: String, newCompanyLogo: UIImage, cellBackgroundColor: UIColor) {
        companySymbol.text = newCompanySymbol
        companyTitle.text = newCompanyTitle
        companyLogo.image = newCompanyLogo
        contentView.backgroundColor = cellBackgroundColor
    }
}
