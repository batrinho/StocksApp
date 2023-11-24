//
//  RequestsView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol RequestsViewDelegate: AnyObject {
    func handleRequestButtonTap(name: String)
}

class RequestsView: UIView {
    weak var delegate: RequestsViewDelegate?
    
    // MARK: - UI
    private var popularRequestView: RequestView
    private var recentRequestView: RequestView

    init(frame: CGRect, popularRequestsArray: [String], recentRequestsArray: [String]) {
        self.popularRequestView = RequestView(
            frame: .zero,
            title: "Popular Requests",
            array: popularRequestsArray)
        self.recentRequestView = RequestView(
            frame: .zero,
            title: "Recent Requests",
            array: recentRequestsArray)
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        popularRequestView.delegate = self
        recentRequestView.delegate = self
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(popularRequestView)
        addSubview(recentRequestView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            popularRequestView.topAnchor.constraint(equalTo: topAnchor),
            popularRequestView.leadingAnchor.constraint(equalTo: leadingAnchor),
            popularRequestView.trailingAnchor.constraint(equalTo: trailingAnchor),
            popularRequestView.heightAnchor.constraint(equalToConstant: 170),
            
            recentRequestView.topAnchor.constraint(equalTo: popularRequestView.bottomAnchor),
            recentRequestView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recentRequestView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recentRequestView.heightAnchor.constraint(equalToConstant: 170),
        ])
    }
}

extension RequestsView: RequestViewDelegate {
    func handleRequestButtonTap(name: String) {
        delegate?.handleRequestButtonTap(name: name)
    }
}
