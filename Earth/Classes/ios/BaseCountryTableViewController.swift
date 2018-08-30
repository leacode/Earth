//
//  BaseCountryTableViewController.swift
//  Earth
//
//  Created by leacode on 2018/8/19.
//
#if os(iOS)
class BaseCountryTableViewController: UITableViewController {

    let cellId = "countryCell"
    
    var settings: CountryPickerViewController.Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: CountryCell, forCountry country: Country) {
        
        cell.textLabel?.text = country.localizedName + "(\(country.code))"
        
        if settings?.showFlags ?? true {
            if let flag = country.flag {
                let newSize = CGSize(width: 28.0, height: 28.0 * flag.size.height / flag.size.width)
                cell.imageView?.image = flag.resize(size: newSize)
            }
        }
        
        var subTitle = ""
        
        if settings?.showEmojis ?? true {
            subTitle += country.emoji + " "
        }
        
        if settings?.showDialCode ?? true {
            subTitle += country.dialCode
        }
        
        if !subTitle.isEmpty {
            cell.detailTextLabel?.text = subTitle
        }
                
    }
    

}
#endif
