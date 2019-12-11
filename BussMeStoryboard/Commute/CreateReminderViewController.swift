//
//  CreateReminderViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 29/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class CreateReminderViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var btnStartTime: UIButton!
    @IBOutlet var btnEndTime: UIButton!
    @IBOutlet var remindDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formStyle()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        
//        DATE PICKER TIME
//        remindDatePicker.isUserInteractionEnabled = false
        remindDatePicker.isHidden = true
        
    }
    
    @IBAction func timeStart(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.addTarget(self, action: Selector(("dueDateChanged:")), for: UIControl.Event.valueChanged)
//        let pickerSize : CGSize = picker.sizeThatFits(.zero)
        picker.frame = CGRect(x: 0.0, y: 620, width: 414 , height: 200)
        picker.backgroundColor = UIColor.systemBackground
        self.view.addSubview(picker)
    }
    
    @IBAction func timeBtnEnd(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
                picker.datePickerMode = UIDatePicker.Mode.time
                picker.addTarget(self, action: Selector(("dueDateChanged:")), for: UIControl.Event.valueChanged)
        //        let pickerSize : CGSize = picker.sizeThatFits(.zero)
                picker.frame = CGRect(x: 0.0, y: 620, width: 414 , height: 200)
                picker.backgroundColor = UIColor.systemBackground
                self.view.addSubview(picker)
    }
    
    func formStyle() {
        titleTextField.borderStyle = UITextField.BorderStyle.roundedRect
    }

    @IBAction func btnStartTime(_ sender: Any) {
//        remindDatePicker.isUserInteractionEnabled = true
        remindDatePicker.isHidden = false
        print("Start Time")
        remindDatePicker.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func btnEndTime(_ sender: Any) {
        remindDatePicker.isUserInteractionEnabled = true
        print("End Time")
        remindDatePicker.backgroundColor = UIColor.systemBackground
    }
    
//    DATE PICKER CHANGE
    @IBAction func remindDatePickerVal(_ sender: UIDatePicker) {
        
    }
}
