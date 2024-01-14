//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol StocksTableViewCellDelegate: AnyObject {
    func handleFavoriteButtonTap(with indexPath: IndexPath)
}

// MARK: - Configurations
final class StocksTableViewCell: UITableViewCell {
    static let identifier = String(describing: StocksTableViewCell.self)
    weak var delegate: StocksTableViewCellDelegate?
    
    // MARK: - UI
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
        super.init(style: style, reuseIdentifier: StocksTableViewCell.identifier)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        ticker: String,
        name: String,
        color: UIColor,
        logo: UIImage,
        favoriteButtonImage: UIImage,
        currentPrice: Double,
        changePrice: Double
    ) {
        companyLogo.image = logo
        currentPriceLabel.text = "$\(currentPrice)"
        priceChangeLabel.text = (changePrice < 0 ? "-$\(changePrice * -1)" : "+$\(changePrice)")
        priceChangeLabel.textColor = (changePrice < 0 ? .systemRed : .systemGreen)
        companySymbol.text = ticker
        companyTitle.text = name
        updateButtonImage(with: favoriteButtonImage)
        backgroundColor = color
        setupView()
    }
    
    private func setupView () {
        selectedBackgroundView?.layer.cornerRadius = 25
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
        companySymbol.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        companyTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    }
    
    private func addConstraints () {
        NSLayoutConstraint.activate([
            companyLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            companyLogo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            companyLogo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            companyLogo.widthAnchor.constraint(equalToConstant: 70),
            
            companySymbol.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17.5),
            companySymbol.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 10),
            companySymbol.heightAnchor.constraint(equalToConstant: 20),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            favoriteButton.leadingAnchor.constraint(equalTo: companySymbol.trailingAnchor, constant: 5),
            favoriteButton.heightAnchor.constraint(equalToConstant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 16),
            
            companyTitle.topAnchor.constraint(equalTo: companySymbol.bottomAnchor),
            companyTitle.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 10),
            companyTitle.heightAnchor.constraint(equalToConstant: 15),
            companyTitle.widthAnchor.constraint(equalToConstant: 130),
            
            currentPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17.5),
            currentPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            currentPriceLabel.heightAnchor.constraint(equalToConstant: 20),
            currentPriceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            priceChangeLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
            priceChangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceChangeLabel.heightAnchor.constraint(equalToConstant: 15),
            priceChangeLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
}

// MARK: - Cell modifications
extension StocksTableViewCell {
    func updateButtonImage(with image: UIImage) {
        favoriteButton.setImage(image, for: .normal)
    }
    
    @objc func favoriteButtonPressed () {
        guard let superview = self.superview as? UITableView,
              let indexPath = superview.indexPath(for: self) else { return }
        delegate?.handleFavoriteButtonTap(with: indexPath)
    }
}
