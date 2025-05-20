//
//  ContactFormViewController.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import UIKit

class ContactFormViewController: UIViewController {
    
    let containerView = AppModalContainerView()
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let closeButton = UIButton(type: .system)
    
    let innerPadding: CGFloat = 24
    let outerPadding: CGFloat = 32

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ContactFormViewController {
    
    func style(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Modal Title"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.90
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        
    }
    
    func layout(){
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(closeButton)
        
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: outerPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -outerPadding),
            containerView.heightAnchor.constraint(equalToConstant: 480)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
