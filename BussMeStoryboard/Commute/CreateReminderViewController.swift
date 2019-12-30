//
//  CreateReminderViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 29/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

var ruteTrip: String = ""
var timeBeforeTrip: String = ""

protocol ReminderDelegate {
    func getRoute(route: String)
    func getTimeBefore(time: String)
}

class CreateReminderViewController: UIViewController, ReminderDelegate {
    func getRoute(route: String) {
        DispatchQueue.main.async {
            self.lblRute.text = route
        }
    }
    
    func getTimeBefore(time: String) {
        DispatchQueue.main.async {
            self.lblTimeBefore.text = time
        }
    }
    

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var btnStartTime: UIButton!
    @IBOutlet var btnEndTime: UIButton!
    @IBOutlet var remindDatePicker: UIDatePicker!
    
    @IBOutlet weak var lblRute: UILabel!
    @IBOutlet weak var lblTimeBefore: UILabel!
    
    var selectedTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formStyle()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        
//        DATE PICKER TIME
//        remindDatePicker.isUserInteractionEnabled = false
        remindDatePicker.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblRute.text = ruteTrip
        lblTimeBefore.text = timeBeforeTrip
    }
    
    @IBAction func timeStart(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
//        picker.addTarget(self, action: Selector(("dueDateChanged:")), for: UIControl.Event.valueChanged)
//        let pickerSize : CGSize = picker.sizeThatFits(.zero)
        picker.frame = CGRect(x: 0.0, y: 620, width: 414 , height: 200)
        picker.backgroundColor = UIColor.systemBackground
        self.view.addSubview(picker)
    }
    
    @IBAction func timeBtnEnd(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
                picker.datePickerMode = UIDatePicker.Mode.time
//                picker.addTarget(self, action: Selector(("dueDateChanged:")), for: UIControl.Event.valueChanged)
        //        let pickerSize : CGSize = picker.sizeThatFits(.zero)
                picker.frame = CGRect(x: 0.0, y: 620, width: 414 , height: 200)
                picker.backgroundColor = UIColor.systemBackground
                self.view.addSubview(picker)
    }
    
    func formStyle() {
        titleTextField.borderStyle = UITextField.BorderStyle.roundedRect
    }

    @IBAction func btnSavePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Reminder Has Been Saved", message: "You will be notified at the desired time.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style {
            case .default:
                self.navigationController?.popViewController(animated: true)
            default:
                print("else")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnStartTime(_ sender: Any) {
//        remindDatePicker.isUserInteractionEnabled = true
        remindDatePicker.isHidden = false
        selectedTime = "start"
        print("Start Time")
        remindDatePicker.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func btnEndTime(_ sender: Any) {
//        remindDatePicker.isUserInteractionEnabled = true
        remindDatePicker.isHidden = false
        selectedTime = "end"
        print("End Time")
        remindDatePicker.backgroundColor = UIColor.systemBackground
    }
    
//    DATE PICKER CHANGE
    @IBAction func remindDatePickerVal(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        var selectedHour = ""
        var selectedMin = ""
        
        if components.hour! < 10 {
            selectedHour = "0\(components.hour!)"
        } else {
            selectedHour = "\(components.hour!)"
        }
        if components.minute! < 10 {
            selectedMin = "0\(components.minute!)"
        } else {
            selectedMin = "\(components.minute!)"
        }
        
        if selectedTime == "start" {
            btnStartTime.setTitle("\(selectedHour):\(selectedMin)", for: .normal)
        } else if selectedTime == "end" {
            btnEndTime.setTitle("\(selectedHour):\(selectedMin)", for: .normal)
        } else {
            print("error")
        }
    }
}

