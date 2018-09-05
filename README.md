# Earth

An easy to use framework to pick names,dial codes,flags and emojis of countries all around the world.

[![CI Status](https://img.shields.io/travis/leacode/Earth.svg?style=flat)](https://travis-ci.org/leacode/Earth)
[![Version](https://img.shields.io/cocoapods/v/Earth.svg?style=flat)](https://cocoapods.org/pods/Earth)
[![License](https://img.shields.io/cocoapods/l/Earth.svg?style=flat)](https://cocoapods.org/pods/Earth)
[![Platform](https://img.shields.io/cocoapods/p/Earth.svg?style=flat)](https://cocoapods.org/pods/Earth)

![](https://github.com/leacode/Earth/blob/master/screenshot/1534778864358.png?raw=true "Optional Title")

![](https://github.com/leacode/Earth/blob/master/screenshot/1534778904323.png?raw=true "Optional Title")

![Alt text](https://github.com/leacode/Earth/blob/master/screenshot/1534778992489.png?raw=true "Optional Title")

## Features

- Support 242 countries with flags, emojis and dial codes
- Support 12 Languages. If it doesn't cover your language, PR is welcomed.
- CountryTextField class for picking country from a picker view
- CountryPickerView allows you to select a country from a UITableView


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0 and above. 
- Mac OS 10.10 and above.


## Installation

Earth is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Earth'
```

## How to use

- Getting countries' infomation (Support both Mac OS and iOS)

```
import Earth

// get all countries 
let countries = CountryKit.countries

// get a country with country code
if let country = CountryKit.country(countryCode: "CN") {

     // use result here
     
     // get country's flag
     flagImageView.image = country.flag
     
     // get country's localized name
     countryTF.text = country.localizedName
}

```

- Showing country picker (only support iOS for now)

```
let countryPicker = CountryPickerViewController()
countryPicker.pickerDelegate = self
present(countryPicker, animated: true, completion: nil)
```

- Custmizing CountryTextField (only support iOS for now)

```
...

var settings = Picker.Settings()
// style
settings.barStyle = UIBarStyle.default  // Set toobar style
settings.displayCancelButton = true     // show cancel button or not

// font
settings.cellFont = UIFont.systemFont(ofSize: 15.0) // set font color

// text
settings.placeholder = "choose a country"  // set a placeholder for the text view
settings.doneButtonText = "Done"           // set done button text
settings.cancelButtonText = "Cancel"       // set cancel button text

// colors
settings.toolbarColor = UIColor.blue                    // set toolbar color
settings.pickerViewBackgroundColor = UIColor.lightGray  // set background color of pickerView
settings.doneButtonColor = .white                       // set text color of done button
settings.cancelButtonColor = .purple                    // set text color of cancel button

// height
settings.rowHeight = 44.0                               // set row height

countryTF.settings = settings
```

Or you can just specify a textView as 'CountryPicker' and set it's delegate 'pickerDelegate' to handle the result.


- Custmizing CountryPickerViewController


```
let countryPicker = CountryPickerViewController()
countryPicker.pickerDelegate = self
        
var settings = CountryPickerViewController.Settings()

// style
settings.prefersLargeTitles = false
settings.hidesSearchBarWhenScrolling = false

// colors
settings.barTintColor = .orange
settings.cancelButtonColor = .white
settings.searchBarTintColor = .black

// texts
settings.searchBarPlaceholder = "搜索"
settings.title = "请选择国家"

// config
settings.showDialCode = true
settings.showFlags = true
settings.showEmojis = true

countryPicker.settings = settings
                
present(countryPicker, animated: true, completion: nil)

```

## Author

**Chunyu Li**

- [Linked in](http://www.linkedin.com/in/春毓-李-96920b92/)
- [简书](https://www.jianshu.com/u/1c5cb3408b0f)
- [Twitter](https://twitter.com/leacode) / [Facebook](https://www.facebook.com/leacode.lea)

## License

Earth is available under the MIT license. See the LICENSE file for more info.


