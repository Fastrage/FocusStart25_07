//
//  ImageTableViewCell.swift
//  FocusStart25_07
//
//  Created by Олег Крылов on 25/07/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let service = Service()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func catCellConfigure(url: String) {
        
        guard let imageUrl = URL(string: url) else {
            print("Bad URL")
            return
        }
        self.errorLabel.isHidden = true
        self.catImageView.image = nil
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.layoutSubviews()
        
        
        DispatchQueue.main.async { [weak self] in
            self?.service.getCatPhoto(url: imageUrl, completion: {image, error  in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self?.catImageView.image = image?.resizeImage(image: image!, targetSize: CGSize(width: 414, height: 350))
                    self?.activityIndicator.stopAnimating()
                    } else {
                        self?.errorLabel.isHidden = false
                        self?.errorLabel.text = error?.localizedDescription
                        self?.activityIndicator.color = .red
                    }
                }
            })
        }
    }
}

extension UIImage {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
