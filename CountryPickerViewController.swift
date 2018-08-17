//
//  CountryPickerViewController.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

import UIKit

public enum PickerMode {
    
    case `default`
    
    case country_name
    case country_flag
    case country_flag_name
    case country_flag_name_dialcode
    
}

public class CountryPickerViewController: UINavigationController {
    
    var countriesViewController: CountriesViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesViewController = CountriesViewController()
        
        self.viewControllers = [countriesViewController]
    }

}

public class CountriesViewController: UIViewController {
    
    let cellId = "countryCell"
    
    var tableView: UITableView!
    
    lazy var countriesInSections = CountryKit.countriesInSections
    lazy var countries: [Country] = CountryKit.countries
    var filteredCountries: [Country] = []
    
    private var pickerMode: PickerMode = .default
    
    public var searchController: UISearchController!
    
    var shouldShowSearchResults: Bool = false

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchController()
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.cancel))
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.title = "Select a country"
    }
    
    @objc func cancel() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureTableView() {
        
        tableView = UITableView()
        
        self.view.addSubview(tableView)
        
        
        let constraints = [NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: tableView, attribute: .top,     relatedBy: .equal, toItem: self.view, attribute: .top,     multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: tableView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
        
        self.view.addConstraints(constraints)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: cellId)
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
    }
    

}

extension CountriesViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if shouldShowSearchResults {
            return filteredCountries.count
        } else {
            return countriesInSections.sectionTitles.count
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredCountries.count
        } else {
            return countriesInSections.countriesInSections[section].count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CountryCell
        
        let country = shouldShowSearchResults ? filteredCountries[indexPath.row] : countriesInSections.countriesInSections[indexPath.section][indexPath.row]
        
        cell.imageView?.image = country.flag?.resize(width: 28.0)
        cell.textLabel?.text = country.localizedName
        
        cell.detailTextLabel?.text = country.dialCode
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return shouldShowSearchResults ? nil : countriesInSections.sectionTitles
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shouldShowSearchResults ? nil : countriesInSections.sectionTitles[section]
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

extension CountriesViewController: UITableViewDelegate {
    
}


extension CountriesViewController: UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            shouldShowSearchResults = false
            tableView.reloadData()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
}

extension CountriesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text?.lowercased() else { return }
        
        filteredCountries = countries.filter({ (country: Country) -> Bool in
            return country.name.lowercased().contains(searchString)
        })
        
        tableView.reloadData()
    }
    
}

class CountryCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.textLabel?.minimumScaleFactor = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
 
    }
    
}
