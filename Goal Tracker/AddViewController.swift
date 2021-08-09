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


//*********************************************************************************
//      CLASS DEFINITION
//*********************************************************************************
class AddViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var goalDescriptionField: UITextField!
    @IBOutlet weak var goalStartDateField: UITextField!
    @IBOutlet weak var goalEndDateField: UITextField!
    @IBOutlet weak var goalPriorityField: UITextField!
    
    //  MEMBER VARIABLES
    var delegate:ViewController?
    let datePicker = UIDatePicker()
    var darkModeOn = false
    var textSize = 14
    
    
    //*********************************************************************************
    //      VIEW DID LOAD
    //*********************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create New Goal"
        
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveGoal))
        
        self.navigationItem.rightBarButtonItem = save
        // Do any additional setup after loading the view.
        
        createDatePicker_start(goalStartDateField)
        createDatePicker_end(goalEndDateField)
        UpdateViewDarkMode()
        UpdateTextSize()
    }
    
    //*********************************************************************************
    //      SETTINGS ADJUSTMENTS (TEXT SIZE AND DARK MODE)
    //*********************************************************************************
    func UpdateTextSize(){
        goalDescriptionField.font = goalDescriptionField.font!.withSize(CGFloat((textSize)))
        goalStartDateField.font = goalStartDateField.font!.withSize(CGFloat((textSize)))
        goalEndDateField.font = goalEndDateField.font!.withSize(CGFloat((textSize)))
        goalPriorityField.font = goalPriorityField.font!.withSize(CGFloat((textSize)))
    }
    
    
    
    func UpdateViewDarkMode(){
        
        if darkModeOn{
            view.backgroundColor = UIColor.darkGray
        }
        else{
            view.backgroundColor = UIColor.systemBackground
        }
    }
    
    //*********************************************************************************
    //      DATE PICKER STUFF
    //*********************************************************************************
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
    
    //*********************************************************************************
    //      SAVE GOAL
    //*********************************************************************************
    @objc func saveGoal() {
        
        let gDescription = goalDescriptionField.text
        let gStartDate = goalStartDateField.text
        let gEndDate = goalEndDateField.text
        var gPriority = goalPriorityField.text
        if(Int(gPriority ?? "1") ?? 1 > 5){
            gPriority = "5"
        }
        let gStatus = "Incomplete"
        let gPercentComplete = "0"
        let tempGoal = goal(goalDescription: gDescription ?? "Blank Description", goalStartDate: gStartDate ?? "missing", goalEndDate: gEndDate ?? "missing", goalPercentComplete: gPercentComplete, goalStatus: gStatus, goalPriority: gPriority ?? "1")
        delegate?.addGoal(tempGoal)
        self.navigationController?.popViewController(animated: true)
    }

}
