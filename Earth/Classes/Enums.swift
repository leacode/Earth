//
//  Enums.swift
//  Earth
//
//  Created by leacode on 2018/8/21.
//

import Foundation

//public enum CountryContentType: Int {
//
//    case `default` // Show all infos
//
//    case value1 // Left aligned label on left and right aligned label on right with blue text (Used in Settings)
//
//    case value2 // Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
//
//    case subtitle // Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
//
//}

public enum PickerType {
    
    case `default`(items: [String])
    
    case country
    
}
