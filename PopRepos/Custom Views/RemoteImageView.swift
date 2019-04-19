//
//  RemoteImageView.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

/// An `UIImageView` subclass that allows loading image from remote server asynchronously
class RemoteImageView: UIImageView {

    private var downloadTask: URLSessionDataTask? = nil
    
    private lazy var session: URLSession = { () -> URLSession in
        let sessionConfiguration: URLSessionConfiguration = .default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: sessionConfiguration)
    }()
    
    /// Sets a image from url into the image view.
    ///
    /// - Parameter url: the image url.
    func setImage(url: URL?) {
        cancelImageRequest()
        self.image = nil
        guard let url = url else { return }
        downloadTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        downloadTask?.resume()
    }
    
    /// Cancels the current image request if any.
    func cancelImageRequest() {
        downloadTask?.cancel()
        downloadTask = nil
    }

}
