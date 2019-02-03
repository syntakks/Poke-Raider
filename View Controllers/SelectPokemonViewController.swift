//
//  SelectPokemonViewController.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/8/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit
import Firebase
import CoreData


class SelectPokemonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    lazy var pokedexRef = db.collection("pokedex")
    
    var pokedex = PokedexData.shared.pokedex.pokemonArray
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hatchViewController: HatchedViewController?
    var dataPassed: PokemonItem?
    var pokemonImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        // Do any additional setup after loading the view.
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let columns: CGFloat = 3
        let marginsAndInsets = layout.sectionInset.left +
        layout.sectionInset.right + collectionView.safeAreaInsets.left +
        collectionView.safeAreaInsets.right + layout.minimumLineSpacing * CGFloat(columns - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columns)).rounded(.down)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokedex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokedexCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.pokedexImageView.image = #imageLiteral(resourceName: "egg")
        cell.cellLabel.text = pokedex[indexPath.item].name
        let imageUrl = pokedex[indexPath.item].imageUrl
        cell.pokedexImageView.loadImageUsingUrlString(urlString: imageUrl)
        
        if pokedex[indexPath.item].isSelected {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        pokedex[indexPath.item].isSelected = true
        dataPassed = pokedex[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! PokedexCollectionViewCell
        pokemonImage = cell.pokedexImageView.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        pokedex[indexPath.item].isSelected = false
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
    }
    
}
