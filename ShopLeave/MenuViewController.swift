//
//  MenuViewController.swift
//  ShopLeave
//
//  Created by Paczeika Dan on 23/10/2018.
//  Copyright © 2018 Paczeika Dan. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
class MenuViewController: UIViewController {
    @IBOutlet weak var letsGoShoppingLabel: UIButton!
    @IBOutlet weak var myCartLabel: UIButton!
    @IBAction func letsGoShppingButton(_ sender: UIButton) {
        clicksound()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letsGoShoppingLabel.alpha = 0
        myCartLabel.alpha = 0
        
        
    }
    //animatii
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.9) {
            self.letsGoShoppingLabel.alpha = 1
            self.myCartLabel.alpha = 1
        }
        
        
    }
    
    //functie de sound pentru apasarea unui buton
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
    
}





