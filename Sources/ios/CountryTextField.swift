//
//  CountryPicker.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

#if os(iOS)
import UIKit

@objc public class CountryTextField: UITextField {
    
    var picker: Picker!
    
    public var country: Country! {
        didSet {
            self.text = country.localizedName
            if self.isEditing {
                picker?.scrollToCountry(country: country)
            }
        }
    }
    
    public var settings: Picker.Settings! {
        didSet {
            picker?.settings = settings
        }
    }
    
    public weak var pickerDelegate: CountryPickerDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        picker = Picker(textField: self)
        picker?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidBeginEditing(tf:)), name: UITextField.textDidBeginEditingNotification, object: self)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: self)
    }
    
    @objc private func textFieldDidBeginEditing(tf: UITextField) {
        if country != nil {
            picker.scrollToCountry(country: country)
        }
    }
    
    
}

extension CountryTextField: CountryPickerDelegate {
    
    public func didPickCountry(_ picker: Picker, didSelectCountry country: Country) {
        self.country = country
        pickerDelegate?.didPickCountry(picker, didSelectCountry: country)
    }
    
    
}


#endif
