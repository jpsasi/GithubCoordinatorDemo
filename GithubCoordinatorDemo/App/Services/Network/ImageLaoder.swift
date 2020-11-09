//
//  ImageLaoder.swift
//  GithubCoordinatorDemo
//
//  Created by Sasikumar JP on 08/11/20.
//

import UIKit

class ImageLoader {
    let urlSession: URLSession
    
    static var shared: ImageLoader = ImageLoader()
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "image")
        urlSession = URLSession(configuration: configuration)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let imageUrl = URL(string: urlString) else { return nil }
        let dataTask = urlSession.dataTask(with: imageUrl) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200, 
               let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
}
