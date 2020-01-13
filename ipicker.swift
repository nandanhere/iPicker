//
//  ViewController.swift
//  iPicker
//
//  Created by Sumant Sogikar on 15/12/19.
//  Copyright © 2019 Sumant Sogikar. All rights reserved.
//

import UIKit
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {

        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r , green: g, blue: b, alpha: a)
    }

}

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIScrollViewDelegate {
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!
     var ranOnce = false
    var zoomer : CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                Scroll.delegate = self
        Scroll.minimumZoomScale = 1.0
        Scroll.maximumZoomScale = 100.0
    }
    func addCrosshair()
    {
        if ranOnce == false {
            ranOnce = true
            let label = UILabel(frame: CGRect(x:self.myImageView.bounds.width/2  ,y:self.myImageView.bounds.height/2, width:50, height:50))
            label.backgroundColor = UIColor.clear
            label.text = "x"
            label.font = label.font.withSize(40)
            label.textAlignment = NSTextAlignment.center
            self.view.addSubview(label)
            label.isUserInteractionEnabled = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dragGesture(_:)))
            label.addGestureRecognizer(gesture)
        }
    }
    @IBAction func Importer(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        self.present(image , animated: true)
        addCrosshair()
        
    }

    @IBAction func CameraUse(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = true
        self.present(image , animated: true)
        addCrosshair()
        zoomer = 1
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImageView.image = image
            zoomer = 1
        }
        else{}
        self.dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in Scroll : UIScrollView) -> UIView? {
        zoomer = (Scroll.contentSize.height / Scroll.frame.height)
        print(zoomer)
        return self.myImageView
    }
    @objc func dragGesture(_ gesture : UIPanGestureRecognizer) {
        let orignalCenter = CGPoint(x: self.myImageView.bounds.width/2, y: self.myImageView.bounds.height/2)
        let translation = gesture.translation(in: self.myImageView)
        let label = gesture.view!
        if zoomer == 0 { zoomer = 1}
        let newx =   translation.x *  zoomer
        let newy =   translation.y *  zoomer

        label.center = CGPoint(x: label.center.x + newx, y: label.center.y + newy )
         gesture.setTranslation(CGPoint.zero, in: self.myImageView)
            if label.center.x >= myImageView.bounds.maxX || label.center.x <= myImageView.bounds.minX || label.center.y >= myImageView.bounds.maxY || label.center.y <= myImageView.bounds.minY {
            label.center = orignalCenter
        }
        func img(){
            let cgp = CGPoint(x: label.center.x, y: label.center.y)
            let pic = myImageView.image
            let bro = (pic?.getPixelColor(pos: cgp))!
            print(bro)
            color.backgroundColor = UIColor(cgColor: bro.cgColor)
        }
        img()
    }
    
}

