//
//  url.swift
//  atlas
//
//  Created by Nick Mantini on 9/29/24.
//

import Foundation

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
    
    mutating func appendQueryItems(name: String, values: [String]) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        // Append each value in the array as a separate query item with the same key
        for value in values {
            let queryItem = URLQueryItem(name: name, value: value)
            queryItems.append(queryItem)
        }
        
        // Assign the updated query items to the URL components
        urlComponents.queryItems = queryItems
        
        // Update the URL with the new query items
        self = urlComponents.url!
    }
}
