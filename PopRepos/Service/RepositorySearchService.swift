//
//  RepositorySearchService.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 16/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

class RepositorySearchService: Service {
    
    var configuration: ServiceConfiguration
    var endPoint: String = "search/repositories"
    
    init(configuration: ServiceConfiguration) {
        self.configuration = configuration
    }
    
    func fetchPopularSwiftRepositories(atPage page: Int, with query: String?, completion: @escaping (Result<RepositoriesResponse, Error>) -> Void) -> URLSessionDataTask? {
        
        var parameters: [String : Any] = [:]
        parameters["q"] = "\(query ?? "")+language:swift"
        parameters["sort"] = "stars"
        parameters["page"] = page
        
        return request(method: .get, parameters: parameters, completion: completion)
    }
    
}
