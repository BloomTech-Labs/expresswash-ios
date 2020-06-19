//
//  SignUpViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties

    private var passwordButton = UIButton(type: .custom)
    private var confirmButton = UIButton(type: .custom)
    private var currentTappedTextField: UITextField?

    // MARK: - Outlets

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupTextFields()

        view.layoutIfNeeded()
    }

    // MARK: - Methods

    func setupSubviews() {

        borderView.layer.cornerRadius = 10.0
        borderView.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
        borderView.layer.borderWidth = 2.0

        let width = passwordTextField.frame.size.width
        let rect = CGRect(x: CGFloat(width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))

        if passwordTextField.isSecureTextEntry {
            passwordButton.setTitle("●", for: .normal)
        } else {
            passwordButton.setTitle("○", for: .normal)
        }

        passwordButton.setTitleColor(UIColor(named: "Salmon"), for: .normal)
        passwordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordButton.frame = rect
        passwordButton.addTarget(self, action: #selector(self.unhidePassword), for: .touchUpInside)
        passwordTextField.rightView = passwordButton
        passwordTextField.rightViewMode = .always
    }

    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc func unhidePassword() {

        if passwordButton.titleLabel?.text == "●" {
            passwordTextField.isSecureTextEntry = false
            passwordButton.titleLabel?.text = "○"
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordButton.titleLabel?.text = "●"
        }
        setupSubviews()
    }

    // MARK: - Actions

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailAddressTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        UserController.shared.registerUser(account: "client",
                                           with: email,
                                           firstName,
                                           lastName,
                                           password) { (user, error) in
            if let error = error {
                print("Error registering user: \(error)")
                return
            }
            if let user = user {
                UserController.shared.sessionUser.user = user
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "finishedSignUpSegue", sender: self)
                }
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            return true
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
            return true
        } else if textField == emailAddressTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            if let count = textField.text?.count {
                if count >= 8 {
                    minimumLabel.textColor = UIColor.systemGreen
                    registerButton.isEnabled = true
                } else {
                    minimumLabel.textColor = UIColor.init(named: "Salmon")
                    registerButton.isEnabled = false
                }
            }
        }
        return true
    }
}
