//
//  CountryPickerViewController.swift
//  CountryKit
//
//  Created by leacode on 2018/8/15.
//  Copyright © 2018 leacode. All rights reserved.
//

#if os(iOS)
import UIKit

// MARK: - CountryPickerViewControllerDelegate
public protocol CountryPickerViewControllerDelegate: AnyObject {
    func countryPickerController(_ countryPickerController: CountryPickerViewController,
                                 didSelectCountry country: Country)
}

// MARK: - CountryPickerViewControllerDelegateLayout
public protocol CountryPickerViewControllerDelegateLayout: AnyObject {
    func countryPickerController(_ countryPickerController: CountryPickerViewController)
}

// MARK: - CountryPickerViewController
/// wrapped CountriesViewController in a UINavigationController
public class CountryPickerViewController: UINavigationController {
    public struct Settings {
        // style (only available greater or equals to iOS 11.0)
        public var prefersLargeTitles: Bool = true
        public var hidesSearchBarWhenScrolling: Bool = true

        // colors
        public var barTintColor: UIColor?
        public var cancelButtonColor: UIColor?
        public var searchBarTintColor: UIColor?

        // text
        public var title: String = "Select a country"
        public var searchBarPlaceholder: String = "Search"

        // config
        public var showFlags: Bool = true
        public var showEmojis: Bool = true
        public var showDialCode: Bool = true

        public init() {
        }
    }

    public var settings: Settings?

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

        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }

        countriesViewController = CountriesViewController()
        countriesViewController.pickerDelegate = pickerDelegate
        countriesViewController.settings = settings
        viewControllers = [countriesViewController]
    }
}

// MARK: - CountriesViewController
class CountriesViewController: BaseCountryTableViewController {
    weak var pickerDelegate: CountryPickerViewControllerDelegate?

    private lazy var countries: [Country] = CountryKit.countries

    private lazy var countriesInSections = prepareCountriesInSections()

    private var searchController: UISearchController!

    private var resultsController: CountryResultsTableController!

    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()

        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                       target: self,
                                       action: #selector(cancel))
        leftItem.tintColor = settings?.cancelButtonColor ?? UIColor.blue
        navigationItem.leftBarButtonItem = leftItem

        title = settings?.title ?? "Select a country"

        configUI()
    }
    
    // MARK: - Config

    func configUI() {
        guard let settings = settings else { return }

        navigationController?.navigationBar.barTintColor = settings.barTintColor
    }

    func configureSearchController() {
        resultsController = CountryResultsTableController()
        resultsController.tableView.delegate = self
        resultsController.settings = settings

        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = settings?.searchBarPlaceholder ?? "Search"
        searchController.searchBar.tintColor = settings?.searchBarTintColor ?? .blue

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = settings?.prefersLargeTitles ?? true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = settings?.hidesSearchBarWhenScrolling ?? true
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        searchController.searchBar.delegate = self

        definesPresentationContext = true
    }
    
    // MARK: - Actions
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDatasource
extension CountriesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countriesInSections.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesInSections.countriesInSections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CountryCell else {
            fatalError("Unable to dequeue CountryCell")
        }

        let country = countriesInSections.countriesInSections[indexPath.section][indexPath.row]
        configureCell(cell, forCountry: country)

        return cell
    }
}

// MARK: - UITableViewDelegate
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

// MARK: - UISearchBarDelegate
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

        resultsController.filteredCountries = filteredResults
        resultsController.tableView.reloadData()
    }
}

// MARK: - Utils

extension CountriesViewController {
    func prepareCountriesInSections() -> (sectionTitles: [String], countriesInSections: [[Country]]) {
        let countries = CountryKit.countries
        let collation = UILocalizedIndexedCollation.current()
        var sectionsArray: [[Country]] = []

        var sectionIndexTitles = collation.sectionIndexTitles

        let sectionTitleCount = collation.sectionTitles.count

        for _ in 0 ..< sectionTitleCount {
            sectionsArray.append([])
        }

        for country in countries {
            let sectionNumber = collation.section(for: country,
                                                  collationStringSelector: #selector(Country.getLocalizedName))
            sectionsArray[sectionNumber].append(country)
        }

        var sectionsToRemove: [Int] = []
        for index in 0 ..< sectionTitleCount {
            let arrayInSection = sectionsArray[index]

            if arrayInSection.count == 0 {
                sectionsToRemove.append(sectionsArray.index(index, offsetBy: 0))
            } else {
                if let counties = collation.sortedArray(from: arrayInSection,
                                                        collationStringSelector: #selector(Country.getLocalizedName))
                    as? [Country] {
                    sectionsArray[index] = counties
                }
            }
        }

        sectionIndexTitles.removeObjectAtIndexes(indexes: sectionsToRemove)
        sectionsArray.removeObjectAtIndexes(indexes: sectionsToRemove)

        return (sectionIndexTitles, sectionsArray)
    }
}
#endif
