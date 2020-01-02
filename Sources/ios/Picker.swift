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

// MARK: - Picker
public class Picker: UIControl {
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

    public var settings: Settings = Settings()
    private var pickerType: PickerType!
    var items = [Any]()

    private var pickerView: UIPickerView!
    @IBOutlet public var textField: UITextField!

    public convenience init(textField: UITextField?,
                            pickerType: PickerType = .country) {
        self.init()

        self.pickerType = pickerType

        switch pickerType {
        case let .default(items):
            self.items = items
        default:
            items = CountryKit.countries
        }

        self.textField = textField
        self.textField?.delegate = self
    }

    

    func setValue(index: Int) {
        if index > 0 {
            pickerView(pickerView, didSelectRow: index, inComponent: 0)
        } else {
            textField.text = nil
        }
    }

    func getValue(index: Int) {
    }

    func scrollToCountry(country: Country) {
        if let countries = self.items as? [Country] {
            if let index = countries.firstIndex(where: { (aCountry: Country) -> Bool in
                country.code == aCountry.code
            }) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    // MARK: - UI Components

    let flagWidth: CGFloat = 28.0
    let flagHeight: CGFloat = 20.0
    let dialCodeWidth: CGFloat = 60.0

    var flagImageView: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 15,
                                                  y: settings.rowHeight / 2 - flagHeight / 2,
                                                  width: flagWidth,
                                                  height: flagHeight))
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
    
    // MARK: - Actions
    private var doneButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
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

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: nil,
                                            action: nil)

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
            if textField.text?.count == 0 || !items.contains(where: { (obj: Any) -> Bool in
                (obj as? String) == textField.text
            }) {
                setValue(index: -1)
                textField.placeholder = settings.placeholder
            }
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            if let selectedCountry = items[selectedRow] as? Country {
                delegate?.didPickCountry(self, didSelectCountry: selectedCountry)
            }
        }

        sendActions(for: UIControl.Event.valueChanged)
    }

    @objc @IBAction func cancel(barButton: UIBarButtonItem) {
        textField?.resignFirstResponder()

        if let item = items.first, item is String {
            if textField.text?.count == 0 ||
                !items.contains(where: { (obj: Any) -> Bool in
                    (obj as? String) == textField.text
                }) {
                textField.placeholder = settings.placeholder
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension Picker: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ aTextField: UITextField) -> Bool {
        if items.count > 0 {
            show(sender: aTextField)
            return true
        } else {
            return false
        }
    }

    public func textFieldDidBeginEditing(_ aTextField: UITextField) {
        sendActions(for: UIControl.Event.editingDidBegin)
    }

    public func textFieldDidEndEditing(_ aTextField: UITextField) {
        aTextField.isUserInteractionEnabled = true
        sendActions(for: UIControl.Event.editingDidEnd)
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return false
    }
}

// MARK: - UIPickerViewDataSource
extension Picker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}

// MARK: - UIPickerViewDelegate
extension Picker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = items.first, item is String { textField.text = items[row] as? String }
        sendActions(for: UIControl.Event.valueChanged)
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return settings.rowHeight
    }

    public func pickerView(_ pickerView: UIPickerView,
                           viewForRow row: Int,
                           forComponent component: Int,
                           reusing view: UIView?) -> UIView {
        switch pickerType! {
        case .default:
            let titleView = UILabel()
            titleView.font = settings.cellFont
            titleView.textAlignment = .center
            if let text = items[row] as? String {
                titleView.text = text
            }
            return titleView
        case .country:
            let itemView = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: UIScreen.main.bounds.size.width,
                                                height: settings.rowHeight))

            // flag image view
            let flagView = flagImageView
            // country name label
            let nameLabel = countryNameLabel
            // dial code label
            let dialLabel = dialCodeLabel

            if let country = items[row] as? Country {
                flagView.image = country.flag
                nameLabel.text = country.localizedName
                dialLabel.text = country.dialCode
            }
            itemView.addSubview(flagView)
            itemView.addSubview(nameLabel)
            itemView.addSubview(dialLabel)

            return itemView
        }
    }
}
#endif
