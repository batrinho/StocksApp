//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    private let companyLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        
        image.image = UIImage(named: "loading")
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.backgroundColor = .white
        
        return image
    } ()
    
    private let companyTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = .byTruncatingTail
        title.numberOfLines = 1
        
        return title
    } ()
    
    private let companySymbol: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.lineBreakMode = .byTruncatingTail
        title.setContentHuggingPriority(.required, for: .horizontal)
        title.numberOfLines = 0
        
        return title
    } ()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "Image-1"), for: .normal)
        
        return button
    } ()
    
    private let favoriteButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    } ()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        label.text = "$1 825"
        
        return label
    } ()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.text = "+$0.12 (1,15%)"
        
        return label
    } ()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .trailing
        
        return stackView
    } ()
    
    private let stockSymbolStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        
        return stackView
    } ()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        
        return stackView
    } ()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    } ()
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    } ()
    
    // MARK: - Internal Methods
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StockData().stocksCellIndentifier)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.updateLogo(newCompanyLogo: UIImage(named: "loading.png")!)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting up the View
    
    func setupView () {
        let someView = UIView()
        someView.backgroundColor = .clear
        self.selectedBackgroundView = someView
        
        contentView.addSubview(cellView)
        
        cellView.layer.cornerRadius = 16
        cellView.addSubview(cellStackView)
        
        cellStackView.addArrangedSubview(companyLogo)
        cellStackView.addArrangedSubview(titleStackView)
        cellStackView.addArrangedSubview(priceStackView)
        
        titleStackView.addArrangedSubview(stockSymbolStackView)
        
        stockSymbolStackView.addArrangedSubview(companySymbol)
        stockSymbolStackView.addArrangedSubview(favoriteButtonView)
        
        favoriteButtonView.addSubview(favoriteButton)
        
        titleStackView.addArrangedSubview(companyTitle)
        
        priceStackView.addArrangedSubview(currentPriceLabel)
        priceStackView.addArrangedSubview(priceChangeLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            cellStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            cellStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            cellStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            
            companyLogo.heightAnchor.constraint(equalToConstant: 60),
            companyLogo.widthAnchor.constraint(equalToConstant: 60),
            
            titleStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 5),
            titleStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: -5),
            titleStackView.widthAnchor.constraint(equalToConstant: 150),
            
            favoriteButtonView.topAnchor.constraint(equalTo: stockSymbolStackView.topAnchor),
            favoriteButtonView.bottomAnchor.constraint(equalTo: stockSymbolStackView.bottomAnchor),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20),
            
            priceStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 5),
            priceStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: -5),
            //priceStackView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor)
        ])
    }
    
    // MARK: - Cell modifications
    
    func updateLabels (newCompanySymbol: String, newCompanyTitle: String, cellBackgroundColor: UIColor) {
        companySymbol.text = newCompanySymbol
        companyTitle.text = newCompanyTitle
        cellView.backgroundColor = cellBackgroundColor
    }
    
    func updateLogo (newCompanyLogo: UIImage) {
        companyLogo.image = newCompanyLogo
    }
    
    func updatePrices (currentPrice: Double, priceChange: Double) {
        currentPriceLabel.text = "$\(currentPrice)"
        if priceChange < 0 {
            priceChangeLabel.text = "-$\(priceChange)"
            priceChangeLabel.textColor = .systemRed
        } else {
            priceChangeLabel.text = "+$\(priceChange)"
            priceChangeLabel.textColor = .systemGreen
        }
    }
    
    func setImageButton (newImage: UIImage) {
        favoriteButton.setImage(newImage, for: .normal)
    }
    
    @objc func favoriteButtonPressed () {
        let currentImage = favoriteButton.imageView?.image
        if currentImage == UIImage(named: "Image") {
            StockData.favorites[companySymbol.text!] = false
        } else {
            StockData.favorites[companySymbol.text!] = true
        }
        favoriteButton.setImage(currentImage == UIImage(named: "Image") ? UIImage(named: "Image-1") : UIImage(named: "Image"), for: .normal)
    }
}
