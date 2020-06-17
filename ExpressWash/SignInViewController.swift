//
//  SignInViewController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/23/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var tapExpressWash: UITapGestureRecognizer!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var savePasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignIn.layer.cornerRadius = 10.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        txtEmail.text = UserController.shared.email
        txtPassword.text = UserController.shared.password

        // check to see if a valid token is already available
        UserController.shared.validateToken { valid in
            if valid {
                self.performSegue(withIdentifier: "segueToMain", sender: self)
            }
        }
    }

    // MARK: - Actions

    @IBAction func lblURLTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Visit us online",
                                      message: "Do you want to visit www.expresswash.us in your web browser?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default, handler: { _ in
            if let url = URL(string: "https://www.expresswash.us") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func savePasswordButtonTapped(_ sender: Any) {

        if savePasswordButton.isSelected {
            savePasswordButton.isSelected = false
             // if the user doesn't want to save their password
            UserController.shared.password = nil
        } else {
            savePasswordButton.isSelected = true
        }
    }

    @IBAction func signInTapped(_ sender: Any) {
        guard let email = txtEmail.text, let password = txtPassword.text else {
            let alert = UIAlertController(title: "Invalid inputs",
                                          message: "Please enter an email address and password.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        UserController.shared.authenticate(username: email, password: password) { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "Sign-in failed",
                                                  message: "Incorrect email and/or password.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("Sign-in error: \(error)")
                } else {
                    if self.savePasswordButton.isSelected {
                        // if the user wants to save their password
                        UserController.shared.email = email
                        UserController.shared.password = password
                    }
                    self.performSegue(withIdentifier: "segueToMain", sender: self)
                }
            }
        }
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
         lblURLTapped(sender)
    }

}
