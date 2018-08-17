//
//  Country.swift
//  CountryKit
//
//  Created by leacode on 2018/8/13.
//  Copyright © 2018 leacode. All rights reserved.
//

import UIKit

public class Country: Codable {

    public var name: String
    public var dialCode: String
    public var code: String
    
    public var flag: UIImage? {
        let bundle: Bundle = Bundle(for: CountryKit.self)
        let image = UIImage(named: code.uppercased(), in: bundle, compatibleWith: nil)
        return image
    }
    
    public var localizedName: String {
        let bundle: Bundle = Bundle(for: CountryKit.self)
        return NSLocalizedString(name, tableName: nil, bundle: bundle, value: "", comment: "country name")
    }
    
    @objc func getLocalizedName() -> String {        
        let bundle: Bundle = Bundle(for: CountryKit.self)
        return NSLocalizedString(name, tableName: nil, bundle: bundle, value: "", comment: "country name")
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
    
}
