//
//  Service.swift
//  FocusStart25_07
//
//  Created by Олег Крылов on 29/07/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation
import UIKit
class Service {
    let cache = URLCache.shared
    
    
    func getCatPhoto(url:URL, completion: @escaping (_ image:UIImage?, _ error:Error?) -> Void)  {
        let request = URLRequest(url: url)
        
        if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion(image, nil)
            } else {
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.downloadTask(with: url)  { imageUrl, response, error in
                    
                    guard error == nil else {
                        print("error: \(error!)")
                        completion(nil, error)
                        return
                    }
                    guard let content = imageUrl else {
                        print("no data")
                        return
                    }
                    guard let data = try? Data.init(contentsOf: content) else {
                        return
                    }
                    guard let image = UIImage.init(data: data) else {
                        return
                    }
                    guard let respone = response else {
                        print("no response")
                        return
                    }
                    let cachedData = CachedURLResponse(response: respone, data: data)
                    self.cache.storeCachedResponse(cachedData, for: request)
                    completion(image, nil)
                }
                task.resume()
            }
        }
    }


