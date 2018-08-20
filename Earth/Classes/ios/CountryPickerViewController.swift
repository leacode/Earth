//
//  CountryPickerViewController.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

#if os(iOS)
import UIKit

public enum PickerMode {
    
    case `default`
    
    case country_name
    case country_flag
    case country_flag_name
    case country_flag_name_dialcode
    
}

public protocol CountryPickerViewControllerDelegate: class {
    
    func countryPickerController(_ countryPickerController: CountryPickerViewController, didSelectCountry country: Country)
    
}

/// wrapped CountriesViewController in a UINavigationController
public class CountryPickerViewController: UINavigationController {
    
    public weak var pickerDelegate: CountryPickerViewControllerDelegate? {
        didSet {
            if let controller = self.viewControllers.first as? CountriesViewController {
                controller.pickerDelegate = pickerDelegate
            }
        }
    }
    
    var countriesViewController: CountriesViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesViewController = CountriesViewController()
        countriesViewController.pickerDelegate = pickerDelegate
        
        self.viewControllers = [countriesViewController]
    }

}

class CountriesViewController: BaseCountryTableViewController {
    
    weak var pickerDelegate: CountryPickerViewControllerDelegate?

    lazy var countriesInSections = CountryKit.countriesInSections
    lazy var countries: [Country] = CountryKit.countries
    
    private var pickerMode: PickerMode = .default
    
    var searchController: UISearchController!
    
    var resultsController: CountryResultsTableController!
    
    var selectedSearchedCountry: Country! = nil

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.title = "Select a country"
    }
    
    @objc func cancel() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureSearchController() {
        
        resultsController = CountryResultsTableController()
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, we place the search bar in the navigation bar.
            navigationController?.navigationBar.prefersLargeTitles = true
            
            navigationItem.searchController = searchController
            
            // We want the search bar visible all the time.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, we place the search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }

}

extension CountriesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countriesInSections.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesInSections.countriesInSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CountryCell
        
        let country = countriesInSections.countriesInSections[indexPath.section][indexPath.row]
        configureCell(cell, forCountry: country)
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return countriesInSections.sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countriesInSections.sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

extension CountriesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCountry: Country
        
        if tableView == self.tableView {
            selectedCountry = countriesInSections.countriesInSections[indexPath.section][indexPath.row]
        } else {
            selectedCountry = resultsController.filteredCountries[indexPath.row]
        }
        
        if let pickerViewController = self.navigationController as? CountryPickerViewController {
            pickerDelegate?.countryPickerController(pickerViewController, didSelectCountry: selectedCountry)
        }
        
    }
    
}

extension CountriesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
    
}

extension CountriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let searchText = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
        
        let filteredResults = countries.filter({ (country: Country) -> Bool in
            let countryLocalizedName = country.stringForSearch
            return countryLocalizedName.contains(searchText)
        })
        
        // Hand over the filtered results to our search results table.
        if let resultsController = searchController.searchResultsController as? CountryResultsTableController {
            resultsController.filteredCountries = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
}

// MARK: - UISearchControllerDelegate

extension CountriesViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
}
#endif
