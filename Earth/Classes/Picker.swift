//
//  Picker.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

import UIKit

public enum PickerType {
    
    case `default`(items: [String])
    
    case country_name
    case country_flag
    case country_flag_name
    case country_flag_name_dialcode
    
}

public protocol PickerDelegate: class {
    
    func didPickCountry(_ picker: Picker, didSelectCountry country: Country)
    
}

public class Picker: UIControl, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    public struct Settings {
        
        // style
        public var barStyle = UIBarStyle.default
        public var displayCancelButton: Bool = true
        
        // font
        public var cellFont = UIFont.systemFont(ofSize: 15.0)
        
        // text
        public var placeholder: String = ""
        public var doneButtonText: String?
        public var cancelButtonText: String?
       
        // colors
        public var toolbarColor: UIColor?
        public var pickerViewBackgroundColor: UIColor?
        public var doneButtonColor: UIColor?
        public var cancelButtonColor: UIColor?
        
        // height
        public var rowHeight: CGFloat = 44.0
        
    }
    
    public weak var delegate: PickerDelegate?
    
    public var settings: Settings = Settings();
    private var pickerType: PickerType!
    
    private var pickerView: UIPickerView!
    
    @IBOutlet public weak var textField: UITextField!
    
    var items = [Any]()

    public convenience init(textField: UITextField?,
                            pickerType: PickerType = PickerType.country_flag_name_dialcode) {
        self.init()

        self.pickerType = pickerType
        
        switch pickerType {
        case .default(let items):
            self.items = items
        default:
            self.items = CountryKit.countries
        }
        
        self.textField = textField
        self.textField?.delegate = self
        
    }
    
    @IBAction public func show(sender: Any) {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        
        let toolbar = UIToolbar()
        // Set barStyle
        toolbar.barStyle = settings.barStyle
        // Set toolbarColor
        if let toolbarColor = settings.toolbarColor { toolbar.backgroundColor = toolbarColor }
        
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton: UIBarButtonItem!
        
        if let doneButtonText = settings.doneButtonText {
            doneButton = UIBarButtonItem(title: doneButtonText, style: UIBarButtonItem.Style.done, target: self, action: #selector(done(barButton:)))
        } else {
            doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done(barButton:)))
        }
        if let doneButtonColor = settings.doneButtonColor {
            doneButton.tintColor = doneButtonColor
        }
        
        if settings.displayCancelButton {
            let cancelButton: UIBarButtonItem!
            
            if let cancelButtonText = settings.cancelButtonText {
                cancelButton = UIBarButtonItem(title: cancelButtonText, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel(barButton:)))
            } else {
                cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel(barButton:)))
            }
            
            if let cancelButtonColor = settings.cancelButtonColor {
                cancelButton.tintColor = cancelButtonColor
            }
            
            toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        } else {
            toolbar.setItems([flexibleSpace, doneButton], animated: false)
        }
        
        textField?.inputView = pickerView
        textField?.inputAccessoryView = toolbar
    }
    
    @objc func done(barButton: UIBarButtonItem) {
        textField?.resignFirstResponder()
        
        if let item = items.first, item is String {
            if self.textField.text?.count == 0 || !self.items.contains(where: { (obj: Any) -> Bool in
                (obj as! String) == textField.text
            }) {
                self.setValue(index: -1)
                self.textField.placeholder = self.settings.placeholder
            }
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedCountry = items[selectedRow] as! Country
            delegate?.didPickCountry(self, didSelectCountry: selectedCountry)
        }

        self.sendActions(for: UIControl.Event.valueChanged)
    }
    
    @objc @IBAction func cancel(barButton: UIBarButtonItem) {
        textField?.resignFirstResponder()
        
        if let item = items.first, item is String {
            if self.textField.text?.count == 0 || !self.items.contains(where: { (obj: Any) -> Bool in
                (obj as! String) == textField.text
            }) {
                self.textField.placeholder = self.settings.placeholder
            }
        }
    }
    
    func setValue(index: Int) {
        if index > 0 {
            self.pickerView(pickerView, didSelectRow: index, inComponent: 0)
        } else {
            self.textField.text = nil
        }
    }
    
    func getValue(index: Int) {
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // MARK: - UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = items.first, item is String { self.textField.text = items[row] as? String }
        self.sendActions(for: UIControl.Event.valueChanged)
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return settings.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        switch pickerType! {
        case .country_flag:
            let country = items[row] as! Country
            
            let itemView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: settings.rowHeight))
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28.0, height: 20.0))
            imageView.image = country.flag
            imageView.contentMode = .scaleAspectFit
            imageView.center = itemView.center
            
            itemView.addSubview(imageView)
            
            return itemView
        case .country_name:
            let country = items[row] as! Country
            let titleView = UILabel()
            titleView.font = settings.cellFont
            titleView.textAlignment = .center
            titleView.text = country.name
            return titleView
        case .country_flag_name:
            let country = items[row] as! Country
            let itemView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
            
            let imageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 28.0, height: 20.0))
            imageView.image = country.flag
            
            itemView.addSubview(imageView)
            
            let nameLabel = UILabel(frame: CGRect(x: imageView.frame.maxX + 8,
                                              y: 0,
                                              width: UIScreen.main.bounds.size.width - imageView.bounds.width - 25.0,
                                              height: settings.rowHeight))
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.minimumScaleFactor = 0.5
            nameLabel.numberOfLines = 2
            nameLabel.font = settings.cellFont
            nameLabel.textColor = .black
            nameLabel.text = country.localizedName
            itemView.addSubview(nameLabel)
            
            return itemView
        case .country_flag_name_dialcode:
            let country = items[row] as! Country
            let itemView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
            
            let imageView = UIImageView(frame: CGRect(x: 15, y: 12, width: 28.0, height: 20.0))
            imageView.image = country.flag
            
            itemView.addSubview(imageView)
            
            let dialcodeLabelWidth: CGFloat = 80.0
            
            let nameLabel = UILabel(frame: CGRect(x: 15 + 28 + 8,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width - imageView.bounds.width - 25.0 - dialcodeLabelWidth,
                                                  height: settings.rowHeight))
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.minimumScaleFactor = 0.7
            nameLabel.numberOfLines = 2
            nameLabel.font = settings.cellFont
            nameLabel.textColor = .black
            nameLabel.text = country.localizedName
            itemView.addSubview(nameLabel)
            
            let dialcodeLabel = UILabel(frame: CGRect(x: nameLabel.frame.minX + nameLabel.bounds.width + 8,
                                                      y: 0,
                                                      width: dialcodeLabelWidth,
                                                      height: settings.rowHeight))
            
            dialcodeLabel.font = settings.cellFont
            dialcodeLabel.textColor = .black
            dialcodeLabel.text = country.dialCode
            itemView.addSubview(dialcodeLabel)
            return itemView
        case .default(_):
            let text = items[row] as! String
            let titleView = UILabel()
            titleView.font = settings.cellFont
            titleView.textAlignment = .center
            titleView.text = text
            return titleView
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ aTextField: UITextField) -> Bool {
        if (items.count > 0) {
            self.show(sender: aTextField)
            return true
        } else {
            return false
        }
    }
    
    public func textFieldDidBeginEditing(_ aTextField: UITextField) {
        self.sendActions(for: UIControl.Event.editingDidBegin)
    }
    
    public func textFieldDidEndEditing(_ aTextField: UITextField) {
        aTextField.isUserInteractionEnabled = true
        self.sendActions(for: UIControl.Event.editingDidEnd)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}

