//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol HandleButtonTapDelegate: AnyObject {
    func handleButtonTap (with indexPath: IndexPath, isFavorite: Bool, ticker: String, name: String, logoUrl: String)
}

// MARK: - Configurations
final class StocksTableViewCell: UITableViewCell {
    private var logoUrl = String()
    private var isFavorite: Bool?
    private var didSelectIsFavorite: ((Bool) -> (Void))?
    weak var delegate: HandleButtonTapDelegate?
    
    private let companyLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "")
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    } ()
    
    private let companySymbol: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont(name: "Montserrat-Bold", size: 18)
        return title
    } ()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(StockData.emptyStar, for: .normal)
        return button
    } ()
    
    private let companyTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont(name: "Montserrat-Medium", size: 12)
        return title
    } ()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textColor = .black
        label.textAlignment = .right
        return label
    } ()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textColor = .systemGreen
        label.textAlignment = .right
        return label
    } ()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .trailing
        return stackView
    } ()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StockData.stocksCellIndentifier)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure (ticker: String, name: String, color: UIColor, logoUrl: String, isFavorite: Bool) {
        updateLabels(ticker: ticker, name: name, color: color, logoUrl: logoUrl, isFavorite: isFavorite)
        setupView()
    }
//    configure() method for using delegate
    
//    func configure (newCompanySymbol: String, newCompanyTitle: String, cellBackgroundColor: UIColor, logo: String, isFavorite: Bool, callback: @escaping (Bool) -> Void) {
//        didSelectIsFavorite = callback
//        updateLabels(ticker: newCompanySymbol,
//                     name: newCompanyTitle, 
//                     color: cellBackgroundColor,
//                     logoUrl: logo,
//                     isFavorite: isFavorite)
//        setupView()
//    }
//    configure() method for using closure
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateLogo(newCompanyLogo: UIImage())
        updatePrices(currentPrice: 0.0, priceChange: 0.0)
    }
}

// MARK: - Layout
extension StocksTableViewCell {
    func setupView () {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews () {
        layer.cornerRadius = 25
        contentView.addSubview(companyLogo)
        contentView.addSubview(companySymbol)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(companyTitle)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(priceChangeLabel)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    }
    
    private func addConstraints () {
        NSLayoutConstraint.activate([
            companyLogo.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            companyLogo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            companyLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            companyLogo.widthAnchor.constraint(equalToConstant: 70),
            
            companySymbol.topAnchor.constraint(equalTo: topAnchor, constant: 17.5),
            companySymbol.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 10),
            companySymbol.heightAnchor.constraint(equalToConstant: 20),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            favoriteButton.leadingAnchor.constraint(equalTo: companySymbol.trailingAnchor, constant: 5),
            favoriteButton.heightAnchor.constraint(equalToConstant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 16),
            
            companyTitle.topAnchor.constraint(equalTo: companySymbol.bottomAnchor),
            companyTitle.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 10),
            companyTitle.heightAnchor.constraint(equalToConstant: 15),
            companyTitle.widthAnchor.constraint(equalToConstant: 130),
            
            currentPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17.5),
            currentPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            currentPriceLabel.heightAnchor.constraint(equalToConstant: 20),
            currentPriceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            priceChangeLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
            priceChangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            priceChangeLabel.heightAnchor.constraint(equalToConstant: 15),
            priceChangeLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
}

// MARK: - Cell modifications
extension StocksTableViewCell {
    private func updateLabels (ticker: String, name: String, color: UIColor, logoUrl: String, isFavorite: Bool) {
        companySymbol.text = ticker
        companyTitle.text = name
        backgroundColor = color
        updateButtonImage(isFavorite: isFavorite)
        self.isFavorite = isFavorite
        self.logoUrl = logoUrl
    }
    
    func updateButtonImage (isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? StockData.filledStar : StockData.emptyStar, for: .normal)
    }
    
    func updateLogo (newCompanyLogo: UIImage) {
        companyLogo.image = newCompanyLogo
    }
    
    func updatePrices (currentPrice: Double, priceChange: Double) {
        currentPriceLabel.text = "$\(currentPrice)"
        priceChangeLabel.text = (priceChange < 0 ? "-$\(priceChange * -1)" : "+$\(priceChange)")
        priceChangeLabel.textColor = (priceChange < 0 ? .systemRed : .systemGreen)
    }
    
    @objc func favoriteButtonPressed () {
        isFavorite?.toggle()
        guard let superview = self.superview as? UITableView,
              let newFavoriteState = isFavorite,
              let indexPath = superview.indexPath(for: self) else { return }
        delegate?.handleButtonTap(with: indexPath, isFavorite: newFavoriteState, ticker: companySymbol.text!, name: companyTitle.text!, logoUrl: self.logoUrl)
//        for delegate
        
//        didSelectIsFavorite?(newFavoriteState)
//        for closure
        
    }
}
