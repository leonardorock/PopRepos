//
//  ServiceConfiguration.swift
//  Bookmarks
//
//  Created by Leonardo Oliveira on 31/07/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

struct ServiceConfiguration {
    
    let baseURL: URL
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    static var github: ServiceConfiguration = {
        let baseURL = URL(string: "https://api.github.com/")!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return ServiceConfiguration(baseURL: baseURL, decoder: decoder, encoder: encoder)
    }()
    
}


