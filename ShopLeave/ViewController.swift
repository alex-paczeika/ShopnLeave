//
//  ViewController.swift
//  ShopLeave
//
//  Created by Paczeika Dan on 23/10/2018.
//  Copyright © 2018 Paczeika Dan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
public var myProduct = [String]()
public var myPrice = [Double]()
var player: AVAudioPlayer?
class ViewController: UIViewController   {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel2: UIActivityIndicatorView!
    @IBOutlet weak var signUpButtonAsLabel: UIButton!
    @IBOutlet weak var signInLabelAsLabel: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.isHidden = true
        activityLabel2.isHidden = true
        signUpButtonAsLabel.alpha = 0
        signInLabelAsLabel.alpha = 0
        self.emailField.alpha = 0
        self.passwordField.alpha = 0
        
        
        
    }
    //animatii
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        UIView.animate(withDuration: 1.5) {
            self.signUpButtonAsLabel.alpha = 1
            self.emailField.alpha = 1
            self.passwordField.alpha = 1
            self.signInLabelAsLabel.alpha = 1
            
        }
    }
    
    
    
    //la atingerea butonului se conecteaza la firebase si se logheaza
    @IBAction func signInButton(_ sender: UIButton) {
        
        sender.pulsate()
        clicksound()
        //butonul in care implementam functia de log in in FIrebase
        activityLabel.isHidden = false
        Auth.auth().signIn(withEmail: self.emailField.text! , password: self.passwordField.text!) { (user, error) in
            if user != nil {
                print("You Have Signed In!")
                
                self.activityLabel.isHidden = true
                self.performSegue(withIdentifier: "2", sender: nil)
            }
            if error != nil {
                print("Error")
            }
        }
        
    }
    //la atingerea butonului se conecteaza la firebase si creaza cont
    @IBAction func signUpButton(_ sender: UIButton) {
        
        clicksound()
        //butonul in care implementam functia de Sign UP in FIrebase
        activityLabel2.isHidden = false
        Auth.auth().createUser(withEmail: self.emailField.text! , password: self.passwordField.text!) { (user, error) in
            if user != nil {
                // change 2 to desired number of seconds
                self.signUpButtonAsLabel.isHidden = true
                self.performSegue(withIdentifier: "3", sender: nil)
                self.activityLabel2.isHidden = true
            }
            if error != nil {
                
            }
        }
        
    }
    //functie pentru sunet de clickuri pe butoane
    func clicksound()
    {
        
        
        let path = Bundle.main.path(forResource: "clicksound", ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //apesi done si se inchide keyboardul
    @objc func dimissKeyboard() {
        self.view.endEditing(true)
    }
    
    
}
extension ViewController: UITextFieldDelegate { //extensie pentru keyboard down dupa ce scriem
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
