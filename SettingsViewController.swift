//
//  SettingsViewController.swift
//  Goal Tracker
//
//  Created by Campbell McGavin on 8/8/21.
//

import UIKit

protocol SettingsProtocol{
    func settingsChangeDarkMode(_ darkModeOn:Bool)
    func settingsChangeTextSize(_ textSize:Int)
}


//*********************************************************************************
//      CLASS DEFINITION
//*********************************************************************************
class SettingsViewController: UIViewController {
    
    // MEMBER VARIABLES
    var darkModeOn = false
    var textSize = 18
    var delegate:ViewController?
    
    
    // IB OUTLETS
    @IBOutlet weak var TextStepperOutlet: UIStepper!
    @IBOutlet weak var DarkSwitchOutlet: UISwitch!
    @IBOutlet weak var FontSizeLabel: UITextField!
    
    // IB ACTIONS
    @IBAction func ToggleDarkMode(_ sender: Any) {
        
        // DARK MODE SETTINGS
        let darkSwitch = sender as! UISwitch
        darkModeOn = darkSwitch.isOn

        
        delegate?.settingsChangeDarkMode(darkModeOn)
        UpdateViewDarkMode()
    }
    @IBAction func ChangeFontSizeAction(_ sender: Any) {
        let button = sender as! UIStepper
        textSize = Int(button.stepValue)
        let tempStr = " pt. font"
        
        let fontSize = CGFloat(TextStepperOutlet.value)
        
        FontSizeLabel.font = FontSizeLabel.font!.withSize(fontSize)
        FontSizeLabel.text = String(button.value) + tempStr
        delegate?.settingsChangeTextSize(Int(TextStepperOutlet.value))
    }
    
    
    //*********************************************************************************
    //      VIEW DID LOAD
    //*********************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateViewDarkMode()
        TextStepperOutlet.value = Double(textSize)
        TextStepperOutlet.maximumValue = 22
        TextStepperOutlet.minimumValue = 8
        TextStepperOutlet.stepValue = 1
        TextStepperOutlet.value = Double(textSize)
        UpdateTextSize()
        FontSizeLabel.text = String(textSize) + " pt. font"
        FontSizeLabel.font = FontSizeLabel.font!.withSize(CGFloat(textSize))
        // Do any additional setup after loading the view.
    }

    
    
    //*********************************************************************************
    //      SETTINGS STUFF
    //*********************************************************************************
    func UpdateTextSize(){
        FontSizeLabel.font = FontSizeLabel.font!.withSize(CGFloat(textSize))
    }
    
    func UpdateViewDarkMode(){
        DarkSwitchOutlet.isOn =  darkModeOn
        if darkModeOn{
            view.backgroundColor = UIColor.darkGray
        }
        else{
            view.backgroundColor = UIColor.systemBackground
        }
    }
    


}
