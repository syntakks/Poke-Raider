//
//  RaidViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/7/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit

class RaidViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var hatchedContainer: UIView!
    @IBOutlet weak var eggContainer: UIView!
    
    
    var isHatched = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.layer.cornerRadius = 4.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func statusControlChanged(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            // Egg Status
            isHatched = false
            eggContainer.isHidden = false
            hatchedContainer.isHidden = true
            
        case 1:
            // Hatched Status
            isHatched = true
            eggContainer.isHidden = true
            hatchedContainer.isHidden = false
        default:
            return
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
