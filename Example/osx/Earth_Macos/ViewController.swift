//
//  ViewController.swift
//  Earth_Macos
//
//  Created by leacode on 2018/8/20.
//  Copyright © 2018 leacode. All rights reserved.
//

import Cocoa
import Quartz
import Earth

class ViewController: NSViewController {

    @IBOutlet weak var flagImageView: NSImageView!
    @IBOutlet weak var countryNameTF: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(CountryKit.countries.count)

        if let country = CountryKit.country(countryCode: "CN") {
            flagImageView.image = country.flag
            countryNameTF.stringValue = country.localizedName
        }

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}
