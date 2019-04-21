//
//  EmptyDataView.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 21/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

protocol EmptyDataViewDelegate: class {
    func emptyDataView(_ emptyDataView: EmptyDataView, actionButtonTapped actionButton: UIButton)
}

class EmptyDataView: UIView {
    
    var fontMetrics: UIFontMetrics {
        return UIFontMetrics.default
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 28, weight: .heavy))
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "PrimaryTintColor")
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [innerStackView, actionButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var hidesActionButton: Bool = false {
        didSet {
            if hidesActionButton {
                rootStackView.removeArrangedSubview(actionButton)
                actionButton.removeFromSuperview()
            } else {
                rootStackView.addArrangedSubview(actionButton)
            }
        }
    }
    
    weak var delegate: EmptyDataViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(title: String?, subtitle: String?, actionButtonTitle: String?) {
        super.init(frame: .zero)
        setup()
        titleLabel.text = title
        subtitleLabel.text = subtitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    func setup() {
        addSubview(rootStackView)
        
        let centerYConstraint = rootStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        let centerXConstraint = rootStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        let leadingConstraint = rootStackView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        let topConstraint = rootStackView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        let bottomConstraint = safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: rootStackView.bottomAnchor, constant: 16)
        addConstraints([centerYConstraint, centerXConstraint, leadingConstraint, topConstraint, bottomConstraint])
    }
    
    @objc func actionButtonTapped(_ sender: UIButton) {
        delegate?.emptyDataView(self, actionButtonTapped: sender)
    }
    
}

