//
//  ViewController.swift
//  Earth
//
//  Created by leacode on 08/17/2018.
//  Copyright (c) 2018 leacode. All rights reserved.
//

import UIKit
import Earth

class ViewController: UIViewController {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryTF: CountryTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Config the pickerView

        var settings = Picker.Settings()
        // style
        settings.barStyle            = UIBarStyle.default   // Set toobar style
        settings.displayCancelButton = true                 // show cancel button or not

        // font
        settings.cellFont = UIFont.systemFont(ofSize: 15.0) // set font color

        // text
        settings.placeholder      = "choose a country"  // set a placeholder for the text view
        settings.doneButtonText   = "Done"              // set done button text
        settings.cancelButtonText = "Cancel"            // set cancel button text

        // colors
        settings.toolbarColor              = UIColor.blue        // set toolbar color
        settings.pickerViewBackgroundColor = UIColor.lightGray   // set background color of pickerView
        settings.doneButtonColor           = .white              // set text color of done button
        settings.cancelButtonColor         = .purple             // set text color of cancel button

        // height
        settings.rowHeight = 44.0

        countryTF.settings = settings
        countryTF.pickerDelegate = self

        if let country = CountryKit.country(countryCode: "CN") {
            flagImageView.image = country.flag
            countryTF.country   = country
        }

    }

    @IBAction func selectCountry(_ sender: Any) {

        let countryPicker = CountryPickerViewController()
        countryPicker.pickerDelegate = self

        // Config the appearance of CountryPickerViewController

        var settings = CountryPickerViewController.Settings()

        // style
        settings.prefersLargeTitles          = false
        settings.hidesSearchBarWhenScrolling = false

        // colors
        settings.barTintColor         = .systemOrange
        settings.cancelButtonColor    = .white
        settings.searchBarTintColor   = .black
        settings.searchBarPlaceholder = "搜索"
        settings.title                = "请选择国家"
        settings.showDialCode         = true
        settings.showFlags            = true
        settings.showEmojis           = true

        countryPicker.settings = settings

        present(countryPicker, animated: true, completion: nil)

    }

}

// Handle result from Country PickerView
extension ViewController: CountryPickerDelegate {

    func didPickCountry(_ picker: Picker, didSelectCountry country: Country) {
        flagImageView.image = country.flag
        countryTF.text      = country.localizedName
    }

}

// Handle result from CountryPickerViewController
extension ViewController: CountryPickerViewControllerDelegate {

    func countryPickerController(_ countryPickerController: CountryPickerViewController,
                                 didSelectCountry country: Country) {
        countryPickerController.dismiss(animated: true, completion: nil)
        flagImageView.image = country.flag
        countryTF.country   = country
    }

}
