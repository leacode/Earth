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
        #if os(iOS)
        return UIImage(named: countryCode, in: frameworkBundle, compatibleWith: nil)
        #elseif os(macOS)
        return frameworkBundle.image(forResource: countryCode.uppercased())
        #endif
    }
    #endif

    public static var countries: [Country] = {
        guard let path = frameworkBundle.path(forResource: "countries", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let countriesFromData = try? JSONDecoder().decode([Country].self, from: jsonData) else {
            return []
        }
        return countriesFromData
    }()

    public static func country(countryCode: String) -> Country? {
        return countries.filter { (country: Country) -> Bool in
            return country.code.uppercased() == countryCode.uppercased()
        }.first
    }
}

extension Array {
    mutating func removeObjectAtIndexes(indexes: [Int]) {
        let indexSet = NSMutableIndexSet()

        for index in indexes {
            indexSet.add(index)
        }

        indexSet.enumerate(options: .reverse) { (index, _) in
            self.remove(at: index)
            return
        }
    }

    mutating func removeObjectAtIndexes(indexes: Int...) {
        removeObjectAtIndexes(indexes: indexes)
    }
}
