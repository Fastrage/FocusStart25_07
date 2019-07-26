//
//  ImageTableViewCell.swift
//  FocusStart25_07
//
//  Created by Олег Крылов on 25/07/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func cellConfigure(url: String) {
        
        self.myImage.image = nil
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        guard let imageUrl = URL(string: url) else {
            print("Bad URL")
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.myImage.image = image
                    self?.activityIndicator.stopAnimating()
                }
            } else {
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.downloadTask(with: imageUrl)  { imageUrl, response, error in
                    
                    guard error == nil else {
                        print("error: \(error!)")
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
                        
                        return }
                    guard let respone = response else {
                        print("no response")
                        return
                    }
                    let cachedData = CachedURLResponse(response: respone, data: data)
                    
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async { [weak self] in
                        self?.myImage.image = image
                        self?.activityIndicator.stopAnimating()
                    }
                }
                task.resume()
            }
        }
    }
}
