//
//  EditViewController.swift
//  Goal Tracker
//
//  Created by Campbell McGavin on 7/27/21.
//

import UIKit

protocol EditGoalProtocol{
    func editGoal(_ goal:goal)
}


//*********************************************************************************
//      CLASS DECLARATION
//*********************************************************************************
class EditViewController: UIViewController {
    
    // IB OUTLETS
    @IBOutlet weak var goalDescriptionField: UITextField!
    @IBOutlet weak var goalStartDateField: UITextField!
    @IBOutlet weak var goalEndDateField: UITextField!
    @IBOutlet weak var goalPriorityField: UITextField!
    @IBOutlet weak var goalPercentCompleteSliderField: UISlider!
    @IBOutlet weak var goalStatusLabel: UILabel!
    @IBOutlet weak var goalPercentCompleteLabel: UILabel!
    
    // MEMBER VARIABLES
    var darkModeOn = false
    var goalDescriptionValue: String?
    var goalStartDateValue:String?
    var goalEndDateValue:String?
    var goalPriorityValue:String?
    var goalPercentCompleteValue:String?
    var goalStatusValue:String?
    var textSize = 14
    var delegate:ViewController?
    let datePicker = UIDatePicker()
    
    
    //  IB ACTIONS
    @IBAction func goalRemoveAction(_ sender: Any) {
        delegate?.deleteGoal();
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goalPercentCompleteSlider(_ sender: UISlider) {
        goalPercentCompleteLabel.text = String(Int(sender.value))
        
        if(Int(goalPercentCompleteLabel.text ?? "0") == 100){
            goalStatusLabel.text = "Complete"
        
        }
        else{
            goalStatusLabel.text = "Incomplete"
        }
    }
    
    
    //*********************************************************************************
    //      VIEW DID LOAD
    //*********************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let save = UIBarButtonItem(barButtonSystemItem: .save,
        target: self, action: #selector(saveGoal))
        
        self.navigationItem.rightBarButtonItem = save

        goalDescriptionField.text = goalDescriptionValue
        goalStartDateField.text = goalStartDateValue
        goalEndDateField.text = goalEndDateValue
        goalPriorityField.text = goalPriorityValue
        goalPercentCompleteLabel.text = goalPercentCompleteValue
        goalPercentCompleteSliderField.setValue(Float(goalPercentCompleteValue!)!, animated: true)
        if(Int(goalPercentCompleteValue ?? "0") == 100){
            goalStatusLabel.text = "Complete"
        
        }
        else{
            goalStatusLabel.text = "Incomplete"
        }
        
        // Do any additional setup after loading the view.
        createDatePicker_start(goalStartDateField)
        createDatePicker_end(goalEndDateField)
        UpdateViewDarkMode()
        UpdateTextSize()
    }
    
    //*********************************************************************************
    //      SETTINGS (DARK MODE AND TEXT SIZE)
    //*********************************************************************************
    func UpdateViewDarkMode(){
        
        if darkModeOn{
            view.backgroundColor = UIColor.darkGray
        }
        else{
            view.backgroundColor = UIColor.systemBackground
        }
    }
    
    func UpdateTextSize(){
        goalDescriptionField.font = goalDescriptionField.font!.withSize(CGFloat((textSize)))
        goalStartDateField.font = goalStartDateField.font!.withSize(CGFloat((textSize)))
        goalEndDateField.font = goalEndDateField.font!.withSize(CGFloat((textSize)))
        goalPriorityField.font = goalPriorityField.font!.withSize(CGFloat((textSize)))
    }
    
    //*********************************************************************************
    //      SET UP DATE PICKER
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
        let gStatus = goalStatusLabel.text ?? "Incomplete"
        let gPercentComplete = goalPercentCompleteLabel.text
        let tempGoal = goal(goalDescription: gDescription ?? "Blank Description", goalStartDate: gStartDate ?? "missing", goalEndDate: gEndDate ?? "missing", goalPercentComplete: gPercentComplete ?? "0", goalStatus: gStatus, goalPriority: gPriority ?? "1")
        delegate?.editGoal(tempGoal)
        self.navigationController?.popViewController(animated: true)
    }


}
