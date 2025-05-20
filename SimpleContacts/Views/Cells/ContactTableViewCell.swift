//
//  ContactTableViewCell.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-20.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    
    static let identifier = "ContactTableViewCell"
    
    private let padding: CGFloat = 16
    private let imageSize: CGFloat = 48
    
    private let contactPlaceholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let contactNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Name"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Number"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contactNameLabel, contactNumberLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var primaryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contactPlaceholderImageView, nameStackView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactTableViewCell {
    func configureUI() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(primaryStackView)
    }
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            contactPlaceholderImageView.widthAnchor.constraint(equalToConstant: imageSize),
            contactPlaceholderImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            primaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            primaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            primaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            primaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(contact: ContactItem) {
        contactNameLabel.text = contact.contact_name ?? "Unknown"
        contactNumberLabel.text = contact.contact_number ?? "No Number"
    }
}
