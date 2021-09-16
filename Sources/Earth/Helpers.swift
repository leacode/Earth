//
//  Common.swift
//  Earth-iOS
//
//  Created by leacode on 2018/9/13.
//  Copyright © 2018 leacode. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
var frameworkBundle: Bundle {

    let currentBundle   = Bundle(for: CountryKit.self)
    let bundleURL       = currentBundle.resourceURL?.appendingPathComponent("Earth.bundle")
    let resourceBundle  = Bundle(url: bundleURL!) ?? currentBundle

    return resourceBundle
}
