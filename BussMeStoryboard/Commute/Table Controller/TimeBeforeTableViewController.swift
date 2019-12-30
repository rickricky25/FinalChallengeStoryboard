//
//  TimeBeforeTableViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 17/12/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class TimeBeforeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        timeBeforeTrip = ""
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    var delegate: ReminderDelegate?
    var selectedTime = ""
    
    let arrTime = ["5", "10", "15", "20", "25", "30"]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeforeTimeReuseable")!
        cell.textLabel?.text = "\(self.arrTime[indexPath.row]) minutes"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.textColor = #colorLiteral(red: 1, green: 0.7922968268, blue: 0, alpha: 1)
        timeBeforeTrip = (tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.text!)!
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.font =  UIFont.systemFont(ofSize: 17)
        tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.textColor = UIColor.label
        timeBeforeTrip = ""
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTime.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.getTimeBefore(time: selectedTime)
    }
}
