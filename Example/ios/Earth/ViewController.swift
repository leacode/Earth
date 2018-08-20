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
    @IBOutlet weak var countryTF: CountryPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTF.pickerDelegate = self
        
        if let country = CountryKit.country(countryCode: "CN") {
            flagImageView.image = country.flag
            countryTF.text = country.localizedName
        }
        
    }

    @IBAction func selectCountry(_ sender: Any) {
        
        let countryPicker = CountryPickerViewController()
        countryPicker.pickerDelegate = self
        present(countryPicker, animated: true, completion: nil)
        
    }

}

extension ViewController: PickerDelegate {
    
    func didPickCountry(_ picker: Picker, didSelectCountry country: Country) {
        flagImageView.image = country.flag
        countryTF.text = country.localizedName
    }
    
}

extension ViewController: CountryPickerViewControllerDelegate {
    
    func countryPickerController(_ countryPickerController: CountryPickerViewController, didSelectCountry country: Country) {
        countryPickerController.dismiss(animated: true, completion: nil)
        flagImageView.image = country.flag
        countryTF.text = country.localizedName
    }
    
}

