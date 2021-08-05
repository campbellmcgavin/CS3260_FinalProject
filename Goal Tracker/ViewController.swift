//
//  ViewController.swift
//  Goal Tracker
//
//  Created by Campbell McGavin on 7/27/21.
//

import UIKit
import SQLite3


//*********************************************************************************
//      GLOBAL VARIABLES
//*********************************************************************************

struct goal {
    var goalDescription: String
    var goalStartDate: String
    var goalEndDate: String
    var goalPercentComplete: Int
    var goalStatus: String
    var goalPriority: Int
}

var goals: [goal] = []
var goalsFiltered: [goal] = []

var goalBeingEdited: Int!

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddGoalProtocol, EditGoalProtocol, UISearchBarDelegate{

    //*********************************************************************************
    //      MEMBER VARIABLES
    //*********************************************************************************
    

    @IBOutlet weak var SwitchButton: UISwitch!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var db: OpaquePointer?
    
    //**********************************************************************************
    // table view delegate methods
    //**********************************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(SwitchButton.isOn){
            return goalsFiltered.count
        }
        else{
            return goals.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(SwitchButton.isOn)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.textLabel?.text = goalsFiltered[indexPath.row].goalDescription
            cell.detailTextLabel?.text = goalsFiltered[indexPath.row].goalStatus
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.textLabel?.text = goals[indexPath.row].goalDescription
            cell.detailTextLabel?.text = goals[indexPath.row].goalStatus
            return cell
        }
        

    }
    
    //**********************************************************************************
    // table view data source methods
    //**********************************************************************************
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let destructiveAction = UIContextualAction(style: .destructive, title: "Delete") { (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            goals.remove(at: indexPath.row)
            tableView.reloadData()
            actionPerformed(true)
        }
        return UISwipeActionsConfiguration(actions:[destructiveAction])
    }
    
    
    
    //**********************************************************************************
    // EditItemProtocol and AddItemProtocol Methods.
    //**********************************************************************************
    func addGoal(_ ggg: goal) {
        SwitchButton.isOn = false
        searchBar.text = ""
        goals.append(ggg)
        tableView.reloadData()
    }
    
    func editGoal(_ goal: goal) {
        //item at selected row
        goals[goalBeingEdited].goalDescription  = goal.goalDescription
        goals[goalBeingEdited].goalStartDate  = goal.goalStartDate
        goals[goalBeingEdited].goalEndDate  = goal.goalEndDate
        goals[goalBeingEdited].goalPercentComplete  = goal.goalPercentComplete
        goals[goalBeingEdited].goalStatus  = goal.goalStatus
        goals[goalBeingEdited].goalPriority  = goal.goalPriority
        tableView.reloadData()
      
    }
  
    
    
    
    func deleteGoal() {
        goals.remove(at:goalBeingEdited)
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.title = "Goal Tracker"
        SwitchButton.isOn = false
        searchBar.text = ""
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveToDatabase(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("GoalTracker.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }

        let createTableQuery = "CREATE TABLE IF NOT EXISTS Goals (id INTEGER PRIMARY KEY AUTOINCREMENT, goalDescription VARCHAR, goalStartDate VARCHAR, goalEndDate VARCHAR, goalPercentComplete INTEGER, goalStatus VARCHAR, goalPriority INTEGER)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        readValues()
    }
    //**********************************************************************************
    // Reading from the database
    //**********************************************************************************
    func readValues(){
        
        //first empty the list of Items
        goals.removeAll()
 
        //this is our select query
        let queryString = "SELECT * FROM Goals"
 
        //statement pointer
        var stmt:OpaquePointer?
 
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
 
        
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //let id = sqlite3_column_int(stmt, 0)
            
            let gDescription = String(cString: sqlite3_column_text(stmt, 1))
            let gStartDate = String(cString: sqlite3_column_text(stmt, 2))
            let gEndDate = String(cString: sqlite3_column_text(stmt, 3))
            let gPriority = Int(bitPattern: sqlite3_column_text(stmt, 4))
            let gStatus = String(cString: sqlite3_column_text(stmt, 5))
            let gPercentComplete = Int(bitPattern: sqlite3_column_text(stmt, 1))
            goals.append(
                goal(goalDescription: gDescription, goalStartDate: gStartDate, goalEndDate: gEndDate, goalPercentComplete: gPercentComplete, goalStatus: gStatus, goalPriority: gPriority)
           )

        }
        
        sqlite3_close(db)
 
    }
    
    
    //**********************************************************************************
    // Saving to the database
    //**********************************************************************************
    @objc func saveToDatabase(_ notification:Notification)
    {
        var stmt:OpaquePointer?
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("GoalTracker.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        let deleteFromDb = "DELETE FROM Goals"
        
        if sqlite3_exec(db, deleteFromDb, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error deleting table: \(errmsg)")
        }
        
            goals.forEach{ goal in
                //the insert query
                

                let queryString = "INSERT INTO Goals (goalDescription, goalStartDate,goalEndDate,goalPercentComplete,goalStatus,goalPriority) VALUES (?,?,?,?,?,?)"

                //preparing the query
                if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                    
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return
                }
                
                //binding the parameters
                
                if sqlite3_bind_text(stmt, 1, (goal.goalDescription as NSString).utf8String, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                if sqlite3_bind_text(stmt, 2, (goal.goalStartDate as NSString).utf8String, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                if sqlite3_bind_text(stmt, 3, (goal.goalEndDate as NSString).utf8String, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                
                if sqlite3_bind_int(stmt, 4, Int32((goal.goalPercentComplete ))) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                if sqlite3_bind_text(stmt, 5, (goal.goalStatus as NSString).utf8String, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                if sqlite3_bind_int(stmt, 4, Int32((goal.goalPriority ))) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
                
                
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("failure inserting hero: \(errmsg)")
                            return
                        }
                
                sqlite3_close(db)
                
            }
        
            
        
    }
    
    
    

    //**********************************************************************************
    // Segue stuff
    //**********************************************************************************
    override func prepare(for segue: UIStoryboardSegue,
          sender: Any?)
    {
        if (segue.identifier == "addSegue")
        {
            let view = segue.destination as! AddViewController
            view.delegate = self
        }
        else if (segue.identifier == "editSegue")
        {
            goalBeingEdited = tableView.indexPathForSelectedRow?.row
            let view = segue.destination as! EditViewController
            view.goalDescriptionValue = goals[goalBeingEdited].goalDescription
            view.goalStartDateValue = goals[goalBeingEdited].goalStartDate
            view.goalEndDateValue = goals[goalBeingEdited].goalEndDate
            view.goalPriorityValue = String(goals[goalBeingEdited].goalPriority)
            view.goalPercentCompleteValue = String(goals[goalBeingEdited].goalPercentComplete)
            view.delegate = self
        }
        
    }
    
    //MARK: Search bar config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        goalsFiltered = []
        
        if searchText == ""
        {
            goalsFiltered = goals
        }
        else{
            for goal in goals {
                if goal.goalDescription.lowercased().contains(searchText.lowercased())    ||
                   goal.goalStartDate.lowercased().contains(searchText.lowercased())      ||
                    goal.goalEndDate.lowercased().contains(searchText.lowercased())       ||
                    goal.goalStatus.lowercased().contains(searchText.lowercased())
                {
                    goalsFiltered.append(goal)
                }
            }
        }

        
        self.tableView.reloadData()
    }
    
    @IBAction func `switch`(_ sender: Any) {
        tableView.reloadData()
    }
    
    
}

