//
//  CountryFlags.swift
//  CountryKit
//
//  Created by leacode on 2018/8/11.
//  Copyright © 2018 leacode. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class CountryKit {
    
    #if os(iOS) || os(macOS)
    public static func flag(countryCode: String) -> PlatformImage? {
        
        let frameworkBundle = Bundle(for: CountryKit.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("Earth.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        
        #if os(iOS)
        return UIImage(named: countryCode, in: frameworkBundle, compatibleWith: nil)
        #elseif os(macOS)
        return resourceBundle!.image(forResource: countryCode.uppercased())
        #endif
        
    }
    #endif
    
    public static var countries: [Country] = {
        var countries: [Country]? = nil
        
        if let countryData = countryJSON.data(using: .utf8) {
            countries = try? JSONDecoder().decode([Country].self, from: countryData)
        }

        return countries ?? []
    }()
    
    public static func country(countryCode: String) -> Country? {
        
        return countries.filter { (country: Country) -> Bool in
            return country.code == countryCode
        }.first
        
    }
    
}

extension Array {
    mutating func removeObjectAtIndexes(indexes: [Int]) {
        let indexSet = NSMutableIndexSet()
        
        for index in indexes {
            indexSet.add(index)
        }
        
        indexSet.enumerate(options: .reverse) { (i, _) in
            self.remove(at: i)
            return
        }
    }
    
    mutating func removeObjectAtIndexes(indexes: Int...) {
        removeObjectAtIndexes(indexes: indexes)
    }
}
