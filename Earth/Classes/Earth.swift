//
//  Earth.swift
//  Earth
//
//  Created by leacode on 2018/8/21.
//

import Foundation

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
public typealias PlatformImage = UIImage
#elseif os(macOS)
import Cocoa
typealias PlatformViewController = NSViewController
public typealias PlatformImage = NSImage
#endif

public typealias CountryUtil = CountryKit
