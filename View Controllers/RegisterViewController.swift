//
//  RegisterViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 6/27/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //        guard let email = emailText.text, let password = passwordText.text else { return }
    //        register(email, password)
    
    
    
    func login(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (userResult, error) in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                self.showErrorAlert(title: "Login Error", message: error.localizedDescription)
                return
            } else {
                // On a successful login, send user to the MapViewController
                if let userUID = Auth.auth().currentUser?.uid {
                    print("Successful Login: userUID:  \(userUID)")
                    self.presentMapViewController()
                }
            }
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func presentMapViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        self.present(mapViewController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
