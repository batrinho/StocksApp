//
//  BubbleView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 19.12.2023.
//

import UIKit

final class BubbleView: UIView {
    private let price: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        return label
    }()
    private let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = UIColor.lightGray
        date.textAlignment = .center
        date.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        return date
    }()
    private let triangleImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "triangle"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 17.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(view)
        view.addSubview(stackView)
        stackView.addArrangedSubview(price)
        stackView.addArrangedSubview(date)
        addSubview(triangleImage)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.heightAnchor.constraint(equalToConstant: 60),
            view.widthAnchor.constraint(equalToConstant: 90),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            triangleImage.topAnchor.constraint(equalTo: view.bottomAnchor),
            triangleImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            triangleImage.heightAnchor.constraint(equalToConstant: 5),
            triangleImage.widthAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    func changeLabels(price: String, date: String) {
        self.price.text = price
        self.date.text = date
    }
}
