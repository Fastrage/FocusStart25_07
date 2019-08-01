//
//  DetailViewController.swift
//  FocusStart25_07
//
//  Created by Олег Крылов on 27/07/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cats = Cats()
    var detailedCat = String()
    let service = Service()
    

    override func viewDidLoad() {
        self.detailLabel.isHidden = true
        super.viewDidLoad()
        guard let imageUrl = URL(string: detailedCat) else {
            print("Bad URL")
            return
        }
        self.service.getCatPhoto(url: imageUrl, completion: {image, error  in
            DispatchQueue.main.async {
                self.detailImageView.image = image
                self.detailLabel.text = self.findDescriptionForCat(url: self.detailedCat)
                self.detailLabel.isHidden = false
            }
        })
    }
    
    func findDescriptionForCat(url: String) -> String {
        return cats.descriptionOfCat[cats.urlOfCat.firstIndex(of: url) ?? 0]
    }
}
