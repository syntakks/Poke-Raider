//
//  PokedexCollectionViewCell.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/8/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var pokedexImageView: PokedexImageView!
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.layer.borderColor = UIColor.red.cgColor
                self.layer.borderWidth = 2.0
                cellLabel.backgroundColor = UIColor.red
                cellLabel.textColor = UIColor.white
                
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.layer.borderWidth = 0.5
                cellLabel.backgroundColor = UIColor.white
                cellLabel.textColor = UIColor.black
            }
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()

public class PokedexImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resoponses, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else { print("UIImage data error"); return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }.resume()
    
    }
}
