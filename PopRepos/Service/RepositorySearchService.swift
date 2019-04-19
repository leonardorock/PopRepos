//
//  RepositorySearchService.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 16/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

class RepositorySearchService: Service {
    
    var configuration: ServiceConfiguration
    var endPoint: String = "search/repositories"
    
    init(configuration: ServiceConfiguration) {
        self.configuration = configuration
    }
    
    func fetchPopularSwiftRepositories(atPage page: Int, completion: @escaping (Result<RepositoriesResponse, Error>) -> Void) {
        
        var parameters: [String : Any] = [:]
        parameters["q"] = "language:swift"
        parameters["sort"] = "stars"
        parameters["page"] = page
        
        request(method: .get, parameters: parameters, completion: completion)
    }
    
}
