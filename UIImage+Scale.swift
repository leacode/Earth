//
//  UIImage+Scale.swift
//  CountryKit
//
//  Created by leacode on 2018/8/16.
//  Copyright © 2018 leacode. All rights reserved.
//

import Foundation

extension UIImage {
    
    func resize(width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        
        // size has to be integer, otherwise it could get white lines
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
