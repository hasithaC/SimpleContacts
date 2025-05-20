//
//  AppPrimaryButton.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-20.
//

import UIKit

class AppPrimaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppPrimaryButton {
    private func style(){
        layer.cornerRadius = 8
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundColor = .systemOrange
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
