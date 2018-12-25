//
//  Picker.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol CountryPickerDelegate: class {
    
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
        
        public init() {
            
        }
    }
    
    public weak var delegate: CountryPickerDelegate?
    
    public var settings: Settings = Settings();
    private var pickerType: PickerType!
    
    private var pickerView: UIPickerView!
    
    @IBOutlet public weak var textField: UITextField!
    
    var items = [Any]()

    public convenience init(textField: UITextField?,
                            pickerType: PickerType = .country) {
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
            doneButton = UIBarButtonItem(title: doneButtonText,
                                         style: UIBarButtonItem.Style.done,
                                         target: self,
                                         action: #selector(done(barButton:)))
        } else {
            doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(done(barButton:)))
        }
        
        if let doneButtonColor = settings.doneButtonColor {
            doneButton.tintColor = doneButtonColor
        }
        
        if settings.displayCancelButton {
            let cancelButton: UIBarButtonItem!
            
            if let cancelButtonText = settings.cancelButtonText {
                cancelButton = UIBarButtonItem(title: cancelButtonText,
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(cancel(barButton:)))
            } else {
                cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                               target: self,
                                               action: #selector(cancel(barButton:)))
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
            if self.textField.text?.count == 0 ||
                !self.items.contains(where: { (obj: Any) -> Bool in
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
    
    func scrollToCountry(country: Country) {
        if let countries = self.items as? [Country] {
            
            if let index = countries.index(where: { (aCountry: Country) -> Bool in
                return country.code == aCountry.code
            }) {
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
        }
        
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
        case .default(_):
            let text = items[row] as! String
            let titleView = UILabel()
            titleView.font = settings.cellFont
            titleView.textAlignment = .center
            titleView.text = text
            return titleView
        case .country:
            
            let country = items[row] as! Country
            
            let itemView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: settings.rowHeight))
            
            // flag image view
            let flagView = flagImageView
            flagView.image = country.flag
            
            // country name label
            let nameLabel = countryNameLabel
            nameLabel.text = country.localizedName
            
            // dial code label
            let dialLabel = dialCodeLabel
            dialLabel.text = country.dialCode
            
            itemView.addSubview(flagView)
            itemView.addSubview(nameLabel)
            itemView.addSubview(dialLabel)
            
            return itemView
        }
        
    }
    
    let flagWidth: CGFloat = 28.0
    let flagHeight: CGFloat = 20.0
    let dialCodeWidth: CGFloat = 60.0
    
    var flagImageView: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 15, y: settings.rowHeight / 2 - flagHeight / 2, width: flagWidth, height: flagHeight))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    var countryNameLabel: UILabel {
        let nameLabelFrame = CGRect(x: 15 + 28 + 8,
                                    y: 0,
                                    width: UIScreen.main.bounds.size.width - flagWidth - 25.0 - dialCodeWidth,
                                    height: settings.rowHeight)
        let nameLabel = UILabel(frame: nameLabelFrame)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.numberOfLines = 2
        nameLabel.font = settings.cellFont
        nameLabel.textColor = .black
        
        return nameLabel
    }
    
    var dialCodeLabel: UILabel {
        
        let dialcodeLabelFrame = CGRect(x: UIScreen.main.bounds.size.width - dialCodeWidth - 10,
                                        y: 0,
                                        width: dialCodeWidth,
                                        height: settings.rowHeight)
        let dialcodeLabel = UILabel(frame: dialcodeLabelFrame)
        dialcodeLabel.font = settings.cellFont
        dialcodeLabel.textColor = .black
        
        return dialcodeLabel
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
#endif
