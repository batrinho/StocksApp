//
//  SearchBarView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 29.09.2023.
//

import UIKit

final class SearchBarView: UIView {
    
    var isClicked = false
    var action: (() -> Void)?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderText = "Find company or ticker"
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black // You can also set the placeholder text color here
        ])

        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    } ()
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        addSubview(button)
        
        layer.cornerRadius = 25
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.5),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func toggleButton () {
        button.setImage(UIImage(named: "returnIcon"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
