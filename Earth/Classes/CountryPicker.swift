//
//  CountryPicker.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

import UIKit

@objc public class CountryPicker: UITextField {
    
    var picker: Picker!
    
    public convenience init(data: [Any]) {
        self.init()
        
        picker = Picker(textField: self)
    }

}
