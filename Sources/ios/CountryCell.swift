//
//  CountryCell.swift
//  Earth
//
//  Created by leacode on 2018/8/19.
//
#if os(iOS)
import UIKit

class CountryCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.textLabel?.minimumScaleFactor = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}
#endif
