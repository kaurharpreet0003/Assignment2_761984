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
    
    
    var tasks: [Tasks]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = task.title
        cell?.detailTextLabel?.text = "\(task.days) days"
        return cell!
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
        let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
            print("add day clicked")
        }
        Addaction.backgroundColor = UIColor.blue
        
        
        let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
            
            
                  // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let ManagedContext = appDelegate.persistentContainer.viewContext
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
            do{
                let test = try ManagedContext.fetch(fetchRequest)
                let item = test[indexPath.row] as!NSManagedObject
                self.tasks?.remove(at: indexPath.row)
                ManagedContext.delete(item)
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
               deleteaction.backgroundColor = UIColor.red
               return [Addaction,deleteaction]
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
         //create an instance of app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                // context
                let ManagedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
         do{
             let results = try ManagedContext.fetch(fetchRequest)
             if results is [NSManagedObject]{
                 for result in results as! [NSManagedObject]{
                     let title = result.value(forKey:"title") as! String

                     let days = result.value(forKey: "days") as! Int


                     tasks?.append(Tasks(title: title, days: days))
                     tableView.reloadData()
                 }
             }
         } catch{
             print(error)
         }
         print(tasks!.count )
    }
    
    func updateText(taskArray: [Tasks]){
        tasks = taskArray
        tableView.reloadData()
    }
    

}
