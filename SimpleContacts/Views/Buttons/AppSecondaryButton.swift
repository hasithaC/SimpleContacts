//
//  AppSecondaryButton.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-20.
//

import UIKit

class AppSecondaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppSecondaryButton {
    private func style() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemOrange.cgColor
        
        setTitleColor(.systemOrange, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundColor = .systemBackground
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
