//
//  LoginViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 6/26/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    var ref: DatabaseReference!

    
    let animationDuration = 0.3
    
    let kEmailTopLandscape: CGFloat = -60
    let kEmailTopPortrait: CGFloat = 40
    
    let kLoginTopPortraitLogin: CGFloat = 0
    let kLoginTopPortraitRegister: CGFloat = 40
    
    let kLoginTopLandscapeLogin: CGFloat = 20
    let kLoginTopLandscapeRegister: CGFloat = 20
    
    enum AuthMode {
        case Login
        case Register
    }
    
    enum TextFields: String {
        case email = "email"
        case password = "password"
        case confirmPassword = "confirmPassword"
    }
    
    var authMode: AuthMode = .Login
    
    var activeTextField = UITextField()
    
    // Views
    @IBOutlet weak var crownImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var pokeballImageView: UIImageView!
    @IBOutlet weak var modeButton: UIButton!
    
    
    // Constraints
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.emailText.delegate = self
        self.passwordText.delegate = self
        self.passwordConfirmText.delegate = self
        //self.passwordConfirmText.isHidden = true
        self.passwordConfirmText.alpha = 0.0
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonClicked))
        toolbar.setItems([doneButton], animated: true)
        
        emailText.inputAccessoryView = toolbar
        passwordText.inputAccessoryView = toolbar
        passwordConfirmText.inputAccessoryView = toolbar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func switchModeTo(_ authMode: AuthMode) {
        print("switchModeTo")
        self.authMode = authMode
        let isPortrait =  UIApplication.shared.statusBarOrientation == .portrait ||
        UIApplication.shared.statusBarOrientation == .portraitUpsideDown
        print("isPortrait: \(isPortrait)")
        switch authMode {
        case .Login:
            if isPortrait {
                loginTopConstraint.constant = kLoginTopPortraitLogin
            } else {
                loginTopConstraint.constant = kLoginTopLandscapeLogin
            }
            modeButton.setImage(UIImage(named: "registerButton"), for: .normal)
            sendRequestButton.setImage(UIImage(named: "loginRequest"), for: .normal)
            passwordText.returnKeyType = .go
            //self.passwordConfirmText.isHidden = true
            UIView.animate(withDuration: animationDuration) {
                self.passwordConfirmText.alpha = 0.0
            }
            
            return
        case .Register:
            print("Register")
            if isPortrait {
                print("isPortrait")
                loginTopConstraint.constant = kLoginTopPortraitRegister
            } else {
                print("isLandscape")
                loginTopConstraint.constant = kLoginTopLandscapeRegister
            }
            modeButton.setImage(UIImage(named: "loginButton"), for: .normal)
            sendRequestButton.setImage(UIImage(named: "registerRequest"), for: .normal)
            passwordText.returnKeyType = .next
            //self.passwordConfirmText.isHidden = false
            UIView.animate(withDuration: animationDuration) {
                self.passwordConfirmText.alpha = 1.0
            }
            return
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isPortrait = !UIDevice.current.orientation.isLandscape
        switch authMode {
        case .Login:
            if isPortrait {
                print("Portrait")
                titleImageView.isHidden = false
                pokeballImageView.isHidden = false
                emailTopConstraint.constant = kEmailTopPortrait
                loginTopConstraint.constant = kLoginTopPortraitLogin
            } else {
                print("Landscape")
                titleImageView.isHidden = true
                pokeballImageView.isHidden = true
                emailTopConstraint.constant = kEmailTopLandscape
                loginTopConstraint.constant = kLoginTopLandscapeLogin
            }
        case .Register:
            if isPortrait {
                print("Portrait")
                titleImageView.isHidden = false
                pokeballImageView.isHidden = false
                emailTopConstraint.constant = kEmailTopPortrait
                loginTopConstraint.constant = kLoginTopPortraitRegister
            } else {
                print("Landscape")
                titleImageView.isHidden = true
                pokeballImageView.isHidden = true
                emailTopConstraint.constant = kEmailTopLandscape
                loginTopConstraint.constant = kLoginTopLandscapeRegister
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        if textField.returnKeyType == .next {
            print(".next")
            if textField.restorationIdentifier == "email" {
                self.passwordText.becomeFirstResponder()
            }
            if textField.restorationIdentifier == "password" {
                self.passwordConfirmText.becomeFirstResponder()
            }
            return false
        }
        if textField.returnKeyType == .go {
            print("go")
            self.view.endEditing(true)
            if let email = emailText.text, let password = passwordText.text {
                switch authMode {
                case .Login:
                    login(email, password)
                    return false
                case .Register:
                    if validatePasswords(){
                        register(email, password)
                    }
                    return false
                }
            }
        }
        return false
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        print("sendRequest")
        guard let email = emailText.text, let password = passwordText.text else { return }
        switch authMode {
        case .Login:
            login(email, password)
            return
        case .Register:
            if validatePasswords(){
                register(email, password)
            }
            return
        }
        
    }
    
    @IBAction func modeButton(_ sender: Any) {
        print("modeButton")
        // Check the current AuthMode and handle.
        switch authMode {
        case .Login:
            switchModeTo(.Register)
            return
        case .Register:
            switchModeTo(.Login)
            return
        }
    }
        
    func validatePasswords() -> Bool {
        print("validatePasswords")
        if passwordText.text == passwordConfirmText.text {
            return true
        }
        showErrorAlert(title: "Password Mismatch", message: "Passwords do not match.")
        return false
    }
    
    func register(_ email: String, _ password: String) {
        print("register")
        Auth.auth().createUser(withEmail: email, password: password) {
            (userResult, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showErrorAlert(title: "Register Error", message: error.localizedDescription)
            } else {
                print("Logging in after regiser")
                guard let result = userResult  else { return }
                let uid = result.user.uid
                print("UID: \(uid)")
                let username = String(email.split(separator: "@")[0])
                print("USERNAME: \(username)")
                // Save results to UserDefaults and Firebase
                UserData.shared.user = User(uID: uid, username: username, isUserLoggedIn: false, userLocation: nil)
                UserData.shared.syncronize()
                self.login(email, password)
            }
        }
    }
    
    func login(_ email: String, _ password: String) {
        print("login")
        Auth.auth().signIn(withEmail: email, password: password) { (userResult, error) in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                self.showErrorAlert(title: "Login Error", message: error.localizedDescription)
                return
            } else {
                // On a successful login, send user to the MapViewController
                if let userUID = Auth.auth().currentUser?.uid {
                    print("Successful Login: userUID:  \(userUID)")
                    UserData.shared.updateIsUserLoggedIn(true)
                    self.presentMapViewController()
                }
            }
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        print("showErrorAlert")
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func presentMapViewController() {
        print("showMapViewController")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        self.present(mapViewController, animated: true, completion: nil)
    }
    
    @objc func doneButtonClicked() {
        self.view.endEditing(true)
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
