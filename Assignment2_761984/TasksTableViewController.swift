//
//  TasksTableViewController.swift
//  Assignment2_761984
//
//  Created by Megha Mahna on 2020-01-20.
//  Copyright © 2020 preet. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    @IBOutlet weak var dateSorting: UIBarButtonItem!
    @IBOutlet weak var alphaSort: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tasks: [Tasks]?
    var temp_data:[Tasks]?
    var add = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchBar.delegate = self
        loadCoreData()
        temp_data = tasks
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temp_data?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let t = temp_data![indexPath.row]
        let c = tableView.dequeueReusableCell(withIdentifier: "cell")
        c?.textLabel?.text = t.title
        c?.detailTextLabel?.text = "\(t.days) days  + \(t.counter) completed + \(t.date)"
        
        if tasks?[indexPath.row].counter == self.tasks?[indexPath.row].days {
            c?.textLabel?.text = "Task Complete"
            c?.backgroundColor = UIColor.gray
            c?.detailTextLabel?.text = " "
        }
        
                  
        return c!
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Add_action = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
            print("adding day")
            let alert_controller = UIAlertController(title: "Add Day", message: "Enter the number of days for completing this task", preferredStyle: .alert)
            alert_controller.addTextField { (text_field) in
                text_field.placeholder = "Enter the number of days"
                self.add = text_field.text!
                
                print(self.add)
                
                text_field.text = ""
            }
            
            let cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            cancel_action.setValue(UIColor.darkGray, forKey: "color")
            
            let add_ac = UIAlertAction(title: "Add Day", style: .default) { (alert) in
                 
                let count = alert_controller.textFields?.first?.text
                
                self.tasks?[indexPath.row].counter += Int(count!) ?? 0
                
                if self.tasks?[indexPath.row].counter == self.tasks?[indexPath.row].days{
                    
                    print("....")
                    
                }
                self.tableView.reloadData()
            }
            
            add_ac.setValue(UIColor.brown, forKey: "textColor")
            
             alert_controller.addAction(add_ac)
            alert_controller.addAction(cancel_action)
            
            self.present(alert_controller, animated: true, completion: nil)
            
        }
        Add_action.backgroundColor = UIColor.green
        
        
        let delete_action = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
            
                   let app_Delegate = UIApplication.shared.delegate as! AppDelegate
                   let ManagedContext = app_Delegate.persistentContainer.viewContext
                   let fetch_Request = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
            do{
                let test = try ManagedContext.fetch(fetch_Request)
                let i = test[indexPath.row] as!NSManagedObject
                self.tasks?.remove(at: indexPath.row)
                
                ManagedContext.delete(i)
                
                tableView.reloadData()
                
                do{
                    try ManagedContext.save()
                }
            
                catch{
                    print(error)
                }
            }
            catch{
                print(error)
            }
        }
               delete_action.backgroundColor = UIColor.red
        
               return [Add_action,delete_action]
    }

    
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
          let sorting = self.tasks!
            self.tasks! = sorting.sorted { $0.title < $1.title }
            self.tableView.reloadData()
        
    }

           

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let detailView = segue.destination as? ViewController{
            detailView.delegate = self
            detailView.tasks = tasks
            
       }
    
    }
    
    
    func loadCoreData(){
        tasks = [Tasks]()
        //temp_data = tasks
         //create an instance of app delegate
                let aDelegate = UIApplication.shared.delegate as! AppDelegate
                let mContext = aDelegate.persistentContainer.viewContext
         
         let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
         do{
            
             let results = try mContext.fetch(fRequest)
             if results is [NSManagedObject]{
                 for result in results as! [NSManagedObject]{
                     let title = result.value(forKey:"title") as! String
                    //let counter = result.value(forKey: "counter") as! Int
                                        
                     let days = result.value(forKey: "days") as! Int
                    let date = result.value(forKey: "date") as! String
                    

                    tasks?.append(Tasks(title: title, days: days, date: date ?? " "))
                     tableView.reloadData()
                 }
             }
            
         } catch{
            
             print(error)
         }
         print(tasks!.count )
    }
    
    func updateText(taskarray: [Tasks]){
        tasks = taskarray
        tableView.reloadData()
    }
    
    
    
      func adding_Day(){

            let AC = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)

                   AC.addTextField { (textField ) in
                        textField.placeholder = "number of days"
                       textField.text = ""
                   }

                   let Cancel_Action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                   Cancel_Action.setValue(UIColor.brown, forKey: "titleTextColor")
                   let Add_Item_Action = UIAlertAction(title: "Add Item", style: .default){
                       (action) in
        }
        
        Add_Item_Action.setValue(UIColor.black, forKey: "titleTextColor")
                AC.addAction(Cancel_Action)
                AC.addAction(Add_Item_Action)
                self.present(AC, animated: true, completion: nil)
    }
   
    @IBAction func sortAlphaBtn(_ sender: UIBarButtonItem) {
        
        let A_sort = self.tasks!
        self.tasks! = A_sort.sorted { $0.title < $1.title }
           self.tableView.reloadData()

    }
    
    @IBAction func dateSortingBtn(_ sender: UIBarButtonItem) {

        let d_Sort = self.tasks!
        self.tasks! = d_Sort.sorted { $0.date < $1.date }
           self.tableView.reloadData()

    }
    

}

extension TasksTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        temp_data = searchText.isEmpty ? tasks : tasks?.filter({ (item: Tasks) -> Bool in
            return item.title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
}
