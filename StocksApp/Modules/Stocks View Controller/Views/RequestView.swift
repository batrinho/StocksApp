//
//  RequestsView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 14.09.2023.
//

import UIKit

protocol RequestViewDelegate: AnyObject {
    func handleRequestButtonTap(name: String)
}
 
final class RequestView: UIView {
    private var array: [String]
    weak var delegate: RequestViewDelegate?
    
    // MARK: - UI
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
    
    init(frame: CGRect, title: String, array: [String]) {
        self.label.text = title
        self.array = array
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(label)
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        
        addStackViews()
        addConstraints()
    }
    
    private func addStackViews() {
        stackView.addArrangedSubview(upperStackView)
        stackView.addArrangedSubview(lowerStackView)
        
        let splitArray = array.split()
        for name in splitArray.left {
            let newButton = RequestButton(frame: .zero, name: name)
            newButton.delegate = self
            upperStackView.addArrangedSubview(newButton)
        }
        for name in splitArray.right {
            let newButton = RequestButton(frame: .zero, name: name)
            newButton.delegate = self
            lowerStackView.addArrangedSubview(newButton)
        }
    }
    
    private func addConstraints() {
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
    
    func addRequest(request: String, upper: Bool) {
        switch upper {
        case true:
            let newButton = RequestButton(frame: .zero, name: request)
            newButton.delegate = self
            upperStackView.addArrangedSubview(newButton)
        case false:
            let newButton = RequestButton(frame: .zero, name: request)
            newButton.delegate = self
            lowerStackView.addArrangedSubview(newButton)
        }
    }
}

extension RequestView: RequestButtonDelegate {
    func handleRequestButtonTap(name: String) {
        delegate?.handleRequestButtonTap(name: name)
    }
}
