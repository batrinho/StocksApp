//
//  RequestsView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 14.09.2023.
//

import UIKit

protocol RequestsViewDelegate: AnyObject {
    func handleRequestButtonTap(name: String)
}

final class RequestsView: UIView {
    private var closure: ((String) -> Void)?
    weak var delegate: RequestsViewDelegate?
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        return label
    } ()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 7.5
        stackView.alignment = .leading
        return stackView
    } ()
    
    private var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 7.5
        return stackView
    } ()
    
    private var lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 7.5
        return stackView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String, array: [String]) {
        self.label.text = label
        addSubview(self.label)
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(upperStackView)
        
        updateStackView(array: array)
        
        setupConstraints()
    }
    
    func updateStackView (array: [String]) {
        upperStackView.removeFullyAllArrangedSubviews()
        lowerStackView.removeFullyAllArrangedSubviews()
        
        let splitArray = array.split()
        for i in splitArray.left {
            let newButton = RequestButton()
            newButton.updateLabel(newName: i)
            // here I added weak capturing of this class in order to avoid a retain cycle between newButton and this class
            newButton.addAction { [weak self] buttonTitle in
                guard let self else { return }
//                self.handleButtonTap(buttonTitle: buttonTitle)
//                for closure
                
                self.delegate?.handleRequestButtonTap(name: buttonTitle)
//                for delegate
            }
            upperStackView.addArrangedSubview(newButton)
        }
        stackView.addArrangedSubview(lowerStackView)
        for i in splitArray.right {
            let newButton = RequestButton()
            newButton.updateLabel(newName: i)
            // here I added weak capturing of this class in order to avoid a retain cycle between newButton and this class
            newButton.addAction { [weak self] buttonTitle in
                guard let self else { return }
//                self.handleButtonTap(buttonTitle: buttonTitle)
//                for closure
                
                self.delegate?.handleRequestButtonTap(name: buttonTitle)
//                for delegate
            }
            lowerStackView.addArrangedSubview(newButton)
        }
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 130),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func handleButtonTap(buttonTitle: String) {
        closure?(buttonTitle)
    }
    
    func addAction(_ action: ((String) -> Void)?) {
        self.closure = action
    }
}
