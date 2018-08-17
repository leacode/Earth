//
//  CountryFlags.swift
//  CountryKit
//
//  Created by leacode on 2018/8/11.
//  Copyright © 2018 leacode. All rights reserved.
//

import UIKit

public class CountryKit {
    
    public static func flag(countryCode: String) -> UIImage? {
        let bundle: Bundle = Bundle(for: CountryKit.self)
        
        let image = UIImage(named: countryCode, in: bundle, compatibleWith: nil)
        
        return image
    }
    
    public static var countries: [Country] = {
        var countries: [Country]? = nil
        let bundle = Bundle(for: CountryKit.self)
        
        guard let jsonPath = bundle.path(forResource: "CountryCodes", ofType: "json"),
        let countryData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath))   else {
            return []
        }
        
        countries = try? JSONDecoder().decode([Country].self, from: countryData)
        
        return countries ?? []
    }()
    
    public static func country(countryCode: String) -> Country? {
        
        return countries.filter { (country: Country) -> Bool in
            return country.code == countryCode
        }.first
        
    }
    
    public static var countriesInSections: (sectionTitles: [String], countriesInSections: [[Country]]) {
        
        let countries = self.countries
        let collation = UILocalizedIndexedCollation.current()
        var sectionsArray: [[Country]] = []
        
        var sectionIndexTitles = collation.sectionIndexTitles
        
        let sectionTitleCount = collation.sectionTitles.count
        
        for _ in 0..<sectionTitleCount {
            sectionsArray.append([])
        }
        
        for country in countries {
            let sectionNumber = collation.section(for: country, collationStringSelector: #selector(Country.getLocalizedName))
            sectionsArray[sectionNumber].append(country)
        }
        
        var sectionsToRemove: [Int] = []
        for index in 0..<sectionTitleCount {
            
            let arrayInSection = sectionsArray[index]
            
            if arrayInSection.count == 0 {
                sectionsToRemove.append(sectionsArray.index(index, offsetBy: 0))
            } else {
                let sortedCountriesArraysForSection = collation.sortedArray(from: arrayInSection, collationStringSelector: #selector(Country.getLocalizedName))
                sectionsArray[index] = sortedCountriesArraysForSection as! [Country]
            }
            
        }
        sectionIndexTitles.removeObjectAtIndexes(indexes: sectionsToRemove)
        sectionsArray.removeObjectAtIndexes(indexes: sectionsToRemove)
        
        return (sectionIndexTitles, sectionsArray)
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
