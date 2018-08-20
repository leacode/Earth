//
//  UIImage+Scale.swift
//  CountryKit
//
//  Created by leacode on 2018/8/16.
//  Copyright © 2018 leacode. All rights reserved.
//

import Foundation

extension UIImage {
    
    func resize(size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    
}
