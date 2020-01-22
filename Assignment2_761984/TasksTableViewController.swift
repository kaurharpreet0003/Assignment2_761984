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
        
        if t.counter == t.days {
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
        
        
        let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                    print("Add day")
                    
            
                    let ac = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)
                                   
                    ac.addTextField { (textField ) in
                                    
                        textField.placeholder = "number of days"
                                    
                            self.add = textField.text!
            
                                    
                                       textField.text = ""
                                    
                        }
        
            
            
                    let Cancel_action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
                    Cancel_action.setValue(UIColor.brown, forKey: "titleTextColor")
            
                        let AddItem_Action = UIAlertAction(title: "Add Item", style: .default){
                                       (action) in
                        let a = ac.textFields?.first?.text
                                    
                        self.temp_data?[indexPath.row].counter += Int(a!) ?? 0
                                    
                                    
                        if self.temp_data?[indexPath.row].counter == self.temp_data?[indexPath.row].days{
                                     
                        }
                                 
                    self.tableView.reloadData()
                              
                    }
                AddItem_Action.setValue(UIColor.black, forKey: "titleTextColor")
                        ac.addAction(Cancel_action)
            
                        ac.addAction(AddItem_Action)
            
                    self.present(ac, animated: true, completion: nil)
                }
        
                Addaction.backgroundColor = UIColor.green
                
        
                let delete_action = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                    
                    
                          // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                           let appDele = UIApplication.shared.delegate as! AppDelegate
                    
                           let MContext = appDele.persistentContainer.viewContext
                    
                           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
                    
                    
                    
                    
                    do{
                        
                        let test = try MContext.fetch(fetchRequest)
                        
                        let item = test[indexPath.row] as? NSManagedObject
                        
                        self.temp_data?.remove(at: indexPath.row)
                        
                        self.tasks?.remove(at: indexPath.row)
                        
                        MContext.delete(item!)
                        
                        tableView.reloadData()
                        
                        do{
                            try MContext.save()
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
                return [Addaction,delete_action]
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
        
        let A_sort = self.temp_data!
        self.temp_data! = A_sort.sorted { $0.title < $1.title }
           self.tableView.reloadData()

    }
    
    @IBAction func dateSortingBtn(_ sender: UIBarButtonItem) {

        let d_Sort = self.temp_data!
        self.temp_data! = d_Sort.sorted { $0.date < $1.date }
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
    
    override func viewWillAppear(_ animated: Bool) {
        temp_data = tasks!
        tableView.reloadData()
    }
}
