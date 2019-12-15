//
//  ViewController.swift
//  iPicker
//
//  Created by Sumant Sogikar on 15/12/19.
//  Copyright © 2019 Sumant Sogikar. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIScrollViewDelegate {
    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                Scroll.delegate = self
        Scroll.minimumZoomScale = 1.0
        Scroll.maximumZoomScale = 100.0
    }
    @IBAction func Importer(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        self.present(image , animated: true)
    }
    
    @IBAction func CameraUse(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = true
        self.present(image , animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImageView.image = image
        }
        else{}
        self.dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in Scroll : UIScrollView) -> UIView? {
        return self.myImageView
    }
    
}

