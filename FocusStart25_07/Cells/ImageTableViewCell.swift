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
        
        
        let queue = DispatchQueue.main.async { [weak self] in
            self?.service.getCatPhoto(url: imageUrl, completion: {image, error  in
                DispatchQueue.main.async {
                    if (error == nil) {
                    self?.catImageView.image = image
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
