//
//  Service.swift
//  Bookmarks
//
//  Created by Leonardo Oliveira on 31/07/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol Service: class {
    var endPoint: String { get }
    var configuration: ServiceConfiguration { get }
}

extension Service {
    
    var session: URLSession {
        return .shared
    }
    
    @discardableResult
    func request<T>(resource: String? = nil, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T : Codable {
        var url = configuration.baseURL.appendingPathComponent(endPoint)
        if let resource = resource {
            url.appendPathComponent(resource)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        guard let componentsURL = components?.url else { return nil }
        var urlRequest = URLRequest(url: componentsURL)
        urlRequest.httpMethod = method.rawValue
        return request(request: urlRequest, completion: completion)
    }
    
    @discardableResult
    func request<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask where T : Codable {
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.session.finishTasksAndInvalidate()
            do {
                guard let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode),
                    let data = data,
                    let decodedResponse = try self?.configuration.decoder.decode(T.self, from: data) else {
                    if let error = error {
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                    return
                }
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
        }
        task.resume()
        return task
    }
    
}
