//
//  MenuViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 6/25/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    

}
