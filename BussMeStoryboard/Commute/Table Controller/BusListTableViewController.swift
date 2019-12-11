//
//  BusListTableViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 11/12/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class BusListTableViewController: UITableViewController {

    var bus = ["Breeze - ICE",
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
   
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bus.count
    }
    
    //=== SELECTION STYLE ================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        let text = bus[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

}