//
//  Country.swift
//  CountryKit
//
//  Created by leacode on 2018/8/13.
//  Copyright © 2018 leacode. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class Country: Codable {

    /// the name of the country. e.g. United States
    public var name: String
    
    /// the dial code of the country. e.g. +1
    public var dialCode: String
    
    /// the ISO code of the country. e.g. US
    public var code: String
    
    /// the emoji of the country's flag. e.g. 🇺🇸
    public var emoji: String
    
    #if os(iOS) || os(macOS)
    /// vector image of the country's flag
    public var flag: PlatformImage? {
        #if os(iOS)
        return UIImage(named: code.uppercased(), in: frameworkBundle, compatibleWith: nil)
        #elseif os(macOS)
        return frameworkBundle.image(forResource: NSImage.Name(rawValue: code.uppercased()))
        #endif
    }
    #endif
    
    /// localized name of the country
    public var localizedName: String {
        return NSLocalizedString(name, tableName: "Localizable", bundle: frameworkBundle, value: "", comment: "country name")
    }
    
    #if os(iOS) || os(macOS)
    @objc func getLocalizedName() -> String {
        return self.localizedName
    }
    #endif
    
    var stringForSearch: String {
        return "\(name.lowercased())\(dialCode)\(code.lowercased())\(emoji)\(localizedName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
        case emoji
    }
    
}
