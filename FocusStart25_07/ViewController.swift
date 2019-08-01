//
//  ViewController.swift
//  FocusStart25_07
//
//  Created by Олег Крылов on 25/07/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    //let service = Service()
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addNewCat(_ sender: Any) {
        addNewCatAllertController()
    }
    
    public var cats = Cats()
    var catUrlToPass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let viewController = segue.destination as! DetailViewController
            viewController.detailedCat = catUrlToPass
            viewController.cats = cats
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cats.urlOfCat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageTableViewCell
        cell.catCellConfigure(url: cats.urlOfCat[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.catUrlToPass = cats.urlOfCat[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.cats.urlOfCat.append(imageURl.absoluteString)
            self.cats.descriptionOfCat.append("Этот котик загружен с Вашего устройства, у него пока нет описания :(")
            picker.dismiss(animated: true, completion: nil)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [
                NSIndexPath(row: self.cats.urlOfCat.count-1, section: 0) as IndexPath], with: .automatic)
            self.tableView.endUpdates()
        } else {
            //TODO: Use Photo from camera
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ViewController {
    func addNewCatAllertController() {
        let alertController = UIAlertController(title: "Добавить котика", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Выбрать фото", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.uploadPhotoAllertController()
        }))
        alertController.addAction(UIAlertAction(title: "Добавить из интернета", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.addNewCatPhotoFromWeb()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        present(alertController, animated: true)
    }
    
    func uploadPhotoAllertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Выбрать из галереи", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.openGallery()
        }))
        alertController.addAction(UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.openCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Cancle", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addNewCatPhotoFromWeb()  {
        let alertController = UIAlertController(title: "Добавить котика", message: nil, preferredStyle: .alert)
        alertController.addTextField { (urlOfCat) in
            urlOfCat.placeholder = "Ссылка"
        }
        
        alertController.addTextField { (descrOfCat) in
            descrOfCat.placeholder = "Описание котика"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        let createAction = UIAlertAction(title: "Добавить", style: UIAlertAction.Style.default) { (action) -> Void in
            guard let urlOfCat = alertController.textFields?[0].text else {
                return
            }
            guard let desctOfCat = alertController.textFields?[1].text else {
                return
            }
            self.tableView.beginUpdates()
            self.cats.urlOfCat.append(urlOfCat)
            self.cats.descriptionOfCat.append(desctOfCat)
            self.tableView.insertRows(at: [
                NSIndexPath(row: self.cats.urlOfCat.count-1, section: 0) as IndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: nil)
    }
}
