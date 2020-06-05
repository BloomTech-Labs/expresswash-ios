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
    @IBOutlet weak var segSavePassword: UISegmentedControl!
    @IBOutlet var tapSignUp: UITapGestureRecognizer!
    @IBOutlet var tapForgotPassword: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignIn.layer.cornerRadius = 5.0
        txtEmail.text = UserController.shared.email
        txtPassword.text = UserController.shared.password
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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

    @IBAction func savePasswordChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            // if the user doesn't want to save their password
            UserController.shared.password = nil
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
                    if self.segSavePassword.selectedSegmentIndex == 0 {
                        // if the user wants to save their password
                        UserController.shared.email = email
                        UserController.shared.password = password
                    }
                    self.performSegue(withIdentifier: "segueToMain", sender: self)
                }
            }
        }
    }

    @IBAction func lblForgotPasswordTapped(_ sender: Any) {
        // There is no forgot password feature on the website yet
        // for now, just directing to home page
        lblURLTapped(sender)
    }

}
