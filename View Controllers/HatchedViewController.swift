//
//  HatchedViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/10/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit

class HatchedViewController: UIViewController {
    
    @IBOutlet weak var pokemonButton: UIButton!
    @IBOutlet weak var selectPokemonLabel: UILabel!
    
    var pokemonItem: PokemonItem?
    var pokemonImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonButton.layer.cornerRadius = 10.0
        pokemonButton.layer.borderWidth = 1
        pokemonButton.layer.borderColor = UIColor.red.cgColor
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(HatchedViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTapView() {
        self.view.endEditing(true)
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        print("UNWINDTOTHISVIEW")
        if let selectPokemonViewController = sender.source as? SelectPokemonViewController {
            if let dataPassed = selectPokemonViewController.dataPassed,
                let image = selectPokemonViewController.pokemonImage {
                pokemonItem = dataPassed
                pokemonImage = image
                pokemonButton.setImage(image, for: .normal)
            }
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
