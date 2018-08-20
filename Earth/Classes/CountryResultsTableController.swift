//
//  CountryResultsTableController.swift
//  Earth
//
//  Created by leacode on 2018/8/19.
//

import UIKit

class CountryResultsTableController: BaseCountryTableViewController {

    var filteredCountries: [Country] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CountryCell
        let country = filteredCountries[indexPath.row]
        configureCell(cell, forCountry: country)
        return cell
    }

}
