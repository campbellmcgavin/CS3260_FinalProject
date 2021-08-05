//
//  AddViewController.swift
//  Goal Tracker
//
//  Created by Campbell McGavin on 7/27/21.
//

import UIKit

protocol AddGoalProtocol{
    func addGoal(_ ggg:goal)
}

class AddViewController: UIViewController {

    @IBOutlet weak var goalDescriptionField: UITextField!
    @IBOutlet weak var goalStartDateField: UITextField!
    @IBOutlet weak var goalEndDateField: UITextField!
    @IBOutlet weak var goalPriorityField: UITextField!
    
    var delegate:ViewController?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create New Goal"
        
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveGoal))
        
        self.navigationItem.rightBarButtonItem = save
        // Do any additional setup after loading the view.
        
        createDatePicker_start(goalStartDateField)
        createDatePicker_end(goalEndDateField)
        
    }
    

    func createDatePicker_start(_ uitf_local: UITextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePicker.datePickerMode = .date
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed_start))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        uitf_local.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        uitf_local.inputView = datePicker
    
    }
    
    @objc func donePressed_start(){
        goalStartDateField.text = "\(datePicker.date)"
        self.view.endEditing(true)
        
    }
    
    func createDatePicker_end(_ uitf_local: UITextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePicker.datePickerMode = .date
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed_end))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        uitf_local.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        uitf_local.inputView = datePicker
    
    }
    
    @objc func donePressed_end(){
        goalEndDateField.text = "\(datePicker.date)"
        self.view.endEditing(true)
        
    }
    
    
    @objc func saveGoal() {
        
        let gDescription = goalDescriptionField.text
        let gStartDate = goalStartDateField.text
        let gEndDate = goalEndDateField.text
        var gPriority = Int(goalPriorityField.text ?? "1") ?? 1
        if(gPriority > 5){
            gPriority = 5
        }
        let gStatus = "Incomplete"
        let gPercentComplete = Int(0)
        let tempGoal = goal(goalDescription: gDescription ?? "Blank Description", goalStartDate: gStartDate ?? "missing", goalEndDate: gEndDate ?? "missing", goalPercentComplete: gPercentComplete, goalStatus: gStatus, goalPriority: gPriority)
        delegate?.addGoal(tempGoal)
        self.navigationController?.popViewController(animated: true)
    }

}
