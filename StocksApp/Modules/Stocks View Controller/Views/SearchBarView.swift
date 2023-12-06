//
//  SearchBarView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 29.09.2023.
//

import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func handleTextFieldButton()
    func handleTextFieldChanges(text: String)
    func handleEnter(text: String)
}

final class SearchBarView: UIView {
    weak var delegate: SearchBarViewDelegate?
    
    // MARK: - UI
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderText = "Find company or ticker"
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
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
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textField.delegate = self
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 22.5
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(textField)
        addSubview(button)
    }
    
    private func addConstraints() {
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
    
    @objc
    func buttonClicked () {
        delegate?.handleTextFieldButton()
    }
    
    func updateTextField(text: String) {
        textField.text = text
    }
    
    func updateTextFieldButtonImage(with image: UIImage) {
        button.setImage(image, for: .normal)
    }
    
    func textFieldResignFirstResponder() {
        textField.resignFirstResponder()
    }
}

// MARK: - Text Field Delegate
extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.handleTextFieldChanges(text: "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        delegate?.handleTextFieldChanges(text: text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        delegate?.handleEnter(text: text)
        return true
    }
}

