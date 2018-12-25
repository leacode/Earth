//
//  CountryPickerView.swift
//  CountryKit
//
//  Created by leacode on 2018/8/13.
//  Copyright © 2018 leacode. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol CountryPickerViewDelegate: class {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    
}

public class CountryPickerView: UIPickerView {
    
    public weak var pickerDelegate: CountryPickerViewDelegate?
    
    @IBInspectable
    public var textSize: CGFloat = 15.0 {
        didSet {
            self.reloadAllComponents()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    let countries: [Country] = CountryKit.countries
    
}

extension CountryPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
}

extension CountryPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let itemView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 28.0, height: 20.0))
        imageView.image = countries[row].flag
        
        itemView.addSubview(imageView)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: textSize)
        label.textColor = .black
        label.text = countries[row].localizedName
        label.sizeToFit()
        
        let newFrame = CGRect(x: 15 + 28 + 8, y: 22 - label.frame.height / 2, width: label.frame.width, height: label.frame.height)
        label.frame = newFrame
        
        itemView.addSubview(label)
        
        return itemView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerDelegate?.countryPickerView(self, didSelectCountry: countries[row])
        
        
    }
    
}
#endif
