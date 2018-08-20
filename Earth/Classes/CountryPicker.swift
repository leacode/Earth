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
    
    public weak var pickerDelegate: PickerDelegate? {
        didSet {
            picker?.delegate = pickerDelegate
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        picker = Picker(textField: self)
    }
    
}
