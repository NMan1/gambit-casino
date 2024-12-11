//
//  loadJson.swift
//  gambit
//
//  Created by Nick Mantini on 11/23/24.
//

import Foundation

func loadJSONFileToDictionary(fileName: String) -> [String: Any]? {
    // Get the file path in the app's documents directory
    let fileManager = FileManager.default
    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
        do {
            // Read the file data
            let data = try Data(contentsOf: fileURL)
            
            // Decode the JSON into a dictionary
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            } else {
                print("Failed to decode JSON as a dictionary.")
            }
        } catch {
            print("Error loading JSON file: \(error.localizedDescription)")
        }
    } else {
        print("File path not found.")
    }
    
    return nil
}

func loadJSONFromBundle(fileName: String) -> [[String: Any]]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return json
            }
        } catch {
            print("Error reading JSON file: \(error)")
        }
    } else {
        print("File \(fileName).json not found in bundle.")
    }
    return nil
}
