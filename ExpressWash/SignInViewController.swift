//
//  SignInViewController.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/23/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet var tapExpressWash: UITapGestureRecognizer!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet var tapSignUp: UITapGestureRecognizer!
    @IBOutlet var tapForgotPassword: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSignIn.layer.cornerRadius = 5.0
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    
    @IBAction func lblURLTapped(_ sender: Any) {
        print("hi")
        let alert = UIAlertController(title: "Visit us online", message: "Do you want to visit www.expresswash.us in your web browser?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            if let url = URL(string: "https://www.expresswash.us") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        // handle sign in
    }
    
    @IBAction func lblSignUpTapped(_ sender: Any) {
        // perform segue to Sign Up screen
    }
    
    @IBAction func lblForgotPasswordTapped(_ sender: Any) {
        // do something about forgotten password
    }
    
}
