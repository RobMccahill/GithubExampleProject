//
//  ImageCache.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 14/02/2022.
//

import UIKit

class ImageCache {
    private let downloadQueue = DispatchQueue(label: "image-background-queue")
    private var cache = [String: UIImage]()
    private var completionHandlers = [String: ((UIImage?) -> Void)]()
    
    func image(forUrl urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        //if the image has been fetched, return immediately
        guard cache[urlString] == nil else {
            completionHandler(cache[urlString])
            return
        }
        
        //indicates that a request is already pending for a given url
        guard completionHandlers[urlString] == nil else { return }
        completionHandlers[urlString] = completionHandler
        
        downloadQueue.async {
            var image: UIImage? = nil
            defer {
                DispatchQueue.main.async {
                    self.completionHandlers[urlString]?(image)
                    self.completionHandlers[urlString] = nil
                }
            }
            
            guard let url = URL(string: urlString) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            guard let imageResult = UIImage(data: data) else { return }
            
            image = imageResult
            self.cache[urlString] = image
        }
    }
    
    func removeRequest(forUrl url: String) {
        completionHandlers[url] = nil
    }
    
}
