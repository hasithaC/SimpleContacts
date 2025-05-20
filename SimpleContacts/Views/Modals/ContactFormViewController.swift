//
//  ContactFormViewController.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import UIKit

protocol ContactFormViewControllerDelegate: AnyObject {
    func didUpdateContacts()
}

class ContactFormViewController: UIViewController {
    
    var contact: ContactItem?
    private let viewModel = ContactFormViewModel()
    
    let containerView = AppModalContainerView()
    let primaryStackView = UIStackView()
    let titleLabel = UILabel()
    
    let contactPlaceholderImageView = UIImageView()
    let contactNameTextField = AppTextField()
    let contactNumberTextField = AppTextField()
    let errorMessageLabel = UILabel()
    let primaryButton = AppPrimaryButton()
    let closeButton = AppSecondaryButton()
    
    private let innerPadding: CGFloat = 24
    private let outerPadding: CGFloat = 32
    private let imageSize: CGFloat = 96
    
    weak var delegate: ContactFormViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        setupForm()
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveContact() {
        view.endEditing(true)
        errorMessageLabel.isHidden = true
        
        viewModel.name = contactNameTextField.text ?? ""
        viewModel.number = contactNumberTextField.text ?? ""
        
        guard viewModel.isNameValid else {
            configureErrorMessage(message: "Please enter a contact name.")
            return
        }
        
        guard viewModel.isNumberValid else {
            configureErrorMessage(message: "Please enter a valid phone number.")
            return
        }
        
        if let existingContact = contact {
            viewModel.updateContact(item: existingContact) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.delegate?.didUpdateContacts()
                        self?.dismiss(animated: true)
                        print("Contact updated successfully")
                    case .failure(let error):
                        print("Update failed: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            viewModel.saveContact { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.delegate?.didUpdateContacts()
                        self?.dismiss(animated: true)
                        print("Contact saved successfully")
                    case .failure(let error):
                        print("Save failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension ContactFormViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == contactNameTextField {
            viewModel.name = textField.text ?? ""
        } else if textField == contactNumberTextField {
            viewModel.number = textField.text ?? ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension ContactFormViewController {
    func configureUI() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    
        primaryStackView.axis = .vertical
        primaryStackView.spacing = 12
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contactPlaceholderImageView.image = UIImage(systemName: "person.crop.circle.fill")
        contactPlaceholderImageView.tintColor = .systemOrange
        contactPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        contactPlaceholderImageView.contentMode = .scaleAspectFit
        contactPlaceholderImageView.layer.cornerRadius = 24
        contactPlaceholderImageView.clipsToBounds = true
        
        titleLabel.text = (contact == nil) ? "Create Contact" : "Update Contact"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
                
        contactNameTextField.delegate = self
        contactNameTextField.placeholder = "Contact Name"
        contactNameTextField.keyboardType = .default
        contactNameTextField.autocapitalizationType = .words
        
        contactNumberTextField.delegate = self
        contactNumberTextField.placeholder = "Contact Number"
        contactNumberTextField.keyboardType = .phonePad
        
        errorMessageLabel.font = UIFont.systemFont(ofSize: 12)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.text = "Error Failure"
        errorMessageLabel.isHidden = true
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        primaryButton.setTitle("Save", for: .normal)
        primaryButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(primaryStackView)
        containerView.addSubview(primaryButton)
        containerView.addSubview(closeButton)
        
        primaryStackView.addArrangedSubview(contactPlaceholderImageView)
        primaryStackView.addArrangedSubview(contactNameTextField)
        primaryStackView.addArrangedSubview(contactNumberTextField)
        primaryStackView.addArrangedSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: outerPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -outerPadding),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            
            primaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: outerPadding),
            primaryStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            primaryStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            
            primaryButton.topAnchor.constraint(equalTo: primaryStackView.bottomAnchor, constant: innerPadding),
            primaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            primaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            
            closeButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: innerPadding),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -innerPadding),
            
            contactPlaceholderImageView.widthAnchor.constraint(equalToConstant: imageSize),
            contactPlaceholderImageView.heightAnchor.constraint(equalToConstant: imageSize),
        ])
    }
    
    func setupForm() {
        if let contact = contact {
            contactNameTextField.text = contact.contact_name
            contactNumberTextField.text = contact.contact_number
            viewModel.name = contact.contact_name ?? ""
            viewModel.number = contact.contact_number ?? ""
        }
    }
    
    private func configureErrorMessage(message: String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }

}
