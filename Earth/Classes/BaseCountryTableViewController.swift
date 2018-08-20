//
//  BaseCountryTableViewController.swift
//  Earth
//
//  Created by leacode on 2018/8/19.
//

import UIKit

class BaseCountryTableViewController: UITableViewController {

    let cellId = "countryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: CountryCell, forCountry country: Country) {
        
        if let flag = country.flag {
            
            let newSize = CGSize(width: 28.0, height: 28.0 * flag.size.height / flag.size.width)
            cell.imageView?.image = flag.resize(size: newSize)
        }
        
        cell.textLabel?.text = country.localizedName + "(\(country.code))"
        cell.detailTextLabel?.text = country.emoji + " " + country.dialCode
    }
    

}
