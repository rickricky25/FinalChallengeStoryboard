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
    @IBOutlet var timeStart: UIButton!
    @IBOutlet var timeBtnEnd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formStyle()
        
    
        
        
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
        timeStart.layer.cornerRadius = 10
        timeBtnEnd.layer.cornerRadius = 10
    }

   

}
