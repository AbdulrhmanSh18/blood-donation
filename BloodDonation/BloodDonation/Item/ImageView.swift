//
//  ImageView.swift
//  BloodDonation
//
//  Created by Abdulrhman Abuhyyh on 23/05/1443 AH.
//

import UIKit
let imageCache = NSCache<NSString,UIImage>()
extension UIImageView {
    func circlerImage () {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func loadImageUsingCache (with urlString:String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
        }else {
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try?
                        Data(contentsOf: url){
                        DispatchQueue.main.async {
                            if let downloadImage = UIImage(data: data) {
                                imageCache.setObject(downloadImage, forKey: urlString as NSString)
                                self.image = downloadImage
                            }
                        }
                    }
                }
            }
        }
    }
}
