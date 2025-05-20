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
    let topStackView = UIStackView()
    let bottomStackView = UIStackView()
    let titleLabel = UILabel()
    let closeButton = UIButton(type: .system)
    let contactNameTextField = AppTextField()
    let contactNumberTextField = AppTextField()
    let primaryButton = AppPrimaryButton()
    
    let innerPadding: CGFloat = 24
    let outerPadding: CGFloat = 32
    
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
        
        viewModel.name = contactNameTextField.text ?? ""
        viewModel.number = contactNumberTextField.text ?? ""
        
        guard viewModel.isNameValid else {
            print("Invalid name")
            return
        }
        
        guard viewModel.isNumberValid else {
            print("Invalid number")
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
        
        topStackView.axis = .horizontal
        topStackView.spacing = 8
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 12
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = (contact == nil) ? "Create Contact" : "Update Contact"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        contactNameTextField.delegate = self
        contactNameTextField.placeholder = "Contact Name"
        
        contactNumberTextField.delegate = self
        contactNumberTextField.placeholder = "Contact Number"
        contactNumberTextField.keyboardType = .phonePad
        
        primaryButton.setTitle("Save", for: .normal)
        primaryButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        
    }
    
    func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubview(topStackView)
        containerView.addSubview(bottomStackView)
        containerView.addSubview(primaryButton)
        
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(closeButton)
        
        bottomStackView.addArrangedSubview(contactNameTextField)
        bottomStackView.addArrangedSubview(contactNumberTextField)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: outerPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -outerPadding),
            
            topStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            topStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            topStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: outerPadding),
            bottomStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            bottomStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            
            primaryButton.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: innerPadding),
            primaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            primaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            primaryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -innerPadding),
            
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
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
}
