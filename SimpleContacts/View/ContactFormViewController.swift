//
//  ContactFormViewController.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-19.
//

import UIKit

class ContactFormViewController: UIViewController {
    
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
    
    let viewModel = ContactFormViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ContactFormViewController: UITextFieldDelegate {
    
    func style(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        topStackView.axis = .horizontal
        topStackView.spacing = 8
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 12
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Create Contact"
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
        
        contactNameTextField.delegate = self
        contactNameTextField.placeholder = "Contact Name"
        
        contactNumberTextField.delegate = self
        contactNumberTextField.placeholder = "Contact Number"
        contactNumberTextField.keyboardType = .phonePad
        
        
        primaryButton.setTitle("Save", for: .normal)
        primaryButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        
    }
    
    func layout(){
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
            containerView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            topStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            topStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: outerPadding),
            bottomStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            bottomStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding)
        ])
        
        NSLayoutConstraint.activate([
            primaryButton.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: outerPadding),
            primaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            primaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == contactNameTextField {
            viewModel.name = textField.text ?? ""
        } else if textField == contactNumberTextField {
            viewModel.number = textField.text ?? ""
        }
    }
    
    @objc func saveContact(){
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
        
        viewModel.saveContact { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.dismiss(animated: true, completion: nil)
                    print("Contact saved successfully")
                case .failure(let error):
                    print("Failed to save contact:", error.localizedDescription)
                }
            }
        }
    }
}
