//
//  HalteListTableViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 11/12/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class HalteListTableViewController: UITableViewController {
    
    var delegate: ReminderDelegate?
    var route = ""

    let section = ["Breeze - ICE",
                   "ICE - Breeze",
                   "Avani - Sektor 1.3",
                   "Sektor 1.3 - Avani",
                   "Greenwich Park - Sektor 1.3",
                   "Sektor 1.3 - Greenwich Park",
                   "Intermoda - De Park Rute 1",
                   "De Park Rute 1 - Intermoda",
                   "Intermoda - De Park Rute 2",
                   "De Park Rute 2 - Intermoda",
                   "Intermoda - Vanya Park",
                   "Vanya Park - Intermoda"]
    
    var halte = [["Green Cove","The Breeze",
                  "CBD Utara 1","CBD Utara 3",
                  "CBD Barat 1","CBD Barat 2",
                  "Lobby AEON","ICE - 1",
                  "Lobby ICE","ICE - 5"],
                 
                 ["ICE-5","Lobby ICE",
                  "ICE - 1","Lobby AEON",
                  "CBD Barat 2","CBD Barat 1",
                  "CBD Utara 3","CBD Utara 1",
                  "The Breeze","Green Cove"],
                 
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"],
                 ["a","b","c","d","e"]]
    
    
    
//    for searching
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
//    -------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        ruteTrip = ""

//        for searching
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari Halte..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
//    Heading
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return 1
        return self.section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return halte.count
        return self.halte[section].count
    }
    
    //=== SELECTION STYLE ================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.textColor = #colorLiteral(red: 1, green: 0.7922968268, blue: 0, alpha: 1)
        ruteTrip = (tableView.cellForRow(at: indexPath as IndexPath)?.textLabel!.text)!
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.font =  UIFont.systemFont(ofSize: 17)
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.textColor = UIColor.label
        ruteTrip = ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HalteCellReuseIdentifier")!
//        let text = halte[indexPath.row]
        cell.textLabel?.text = self.halte[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return cell
    }
    
    func updateSearchResult(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.getRoute(route: route)
    }
    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if isSearching { // this is just for SearchBar
//            return autoCompleteDestino.count
//        }
//
//        return autoCompleteDestino.count
//
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
//
//        destinoSearch.text = selectedCell.textLabel!.text!
//        busquedaDestinosText.text = selectedCell.textLabel!.text!
//
//    }}
//}

// for searching
//extension CreateReminderViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
////        todo
//    }
//}

//extension CreateReminderViewController: UITextFieldDelegate {
//public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//    let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//
//    halte.searchDestinos(substring)
//    return true
//}}
//
//
//extension CreateReminderViewController: UITableViewDataSource {
//public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//    let index = indexPath.row as Int
//
//    isSearching = true // this is just for SearchBar
//    if isSearching {
//        if let str = autoCompleteDestino[index].desDestino {
//            cell.textLabel?.text = str
//        }
//    }
//    return cell
//}}
//
//extension CreateReminderViewController: UISearchBarDelegate {
//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    let stringOfUser = (busquedaDestinosText.text)
//
//    DestinoP.searchDestinos(stringOfUser!)
//
//    if  destinoSearch.text == "" {
//        isSearching = false
//        view.endEditing(true)
//        tableView.reloadData()
//        print(isSearching)
//    } else {
//        isSearching = true
//        print(isSearching)
//        print(autoCompleteDestino)
//    }
//
//}}
// ----------
}
