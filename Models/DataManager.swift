//
//  DataManager.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/9/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation

public class DataManager {
    // get Document Directory
    static fileprivate func getDocumentDirectory() -> URL{
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Unable to access document directory.")
        }
    }
    
    // Checks for a pokedex file
    static func pokedexFileExists() -> Bool {
        let url = getDocumentDirectory().appendingPathComponent("pokedex", isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    // Saves any kind of codable objects.
    static func save <T: Encodable> (_ object: T, with fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(object)
            // Check if file already exists.
            if FileManager.default.fileExists(atPath: url.path) {
                print("file exists")
                try FileManager.default.removeItem(at: url)
            }
            let jsonString = String(data: data, encoding: String.Encoding.utf8)
            print("JSON DATA: \(String(describing: jsonString))")
            
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            print("save successful!")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Load any kind of codable objects.
    static func load <T: Decodable> (_ fileName: String, with type: T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Load data from a file.
    static func loadData (_ fileName: String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File not found at path \(url.path)")
        }
        
        print("URL PATH: \(url.path)")
        
        if let data = FileManager.default.contents(atPath: url.path) {
            return data
        } else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Loads all files from a directory.
    static func loadAll <T: Decodable> (_ type: T.Type) -> [T] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [T]()
            
            for fileName in files {
                if fileName == "firestore" {
                    continue
                }
                print("fileName: \(fileName)")
                modelObjects.append(load(fileName, with: type))
                
            }
            return modelObjects
            
        } catch {
            fatalError("Could not load any files.")
        }
    }
    
    
    // Delete a file.
    static func delete (_ fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
