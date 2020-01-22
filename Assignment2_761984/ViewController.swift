//
//  ViewController.swift
//  Assignment2_761984
//
//  Created by Megha Mahna on 2020-01-20.
//  Copyright © 2020 preet. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var tasks: [Tasks]?
    
    weak var delegate: TasksTableViewController?
    
    @IBOutlet var fields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loadCData()
        saveCData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveCData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func saveCData(){
       // call clear core data
        clearCData()
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let ManagedContext = appDelegate.persistentContainer.viewContext
               
                    for task in tasks!{
                        let task_entity = NSEntityDescription.insertNewObject(forEntityName: "Model", into: ManagedContext)
                        task_entity.setValue(task.title, forKey: "title")
                        task_entity.setValue(task.days, forKey: "days")
                        //task_entity.setValue(task.counter, forKey: "counter")
                        task_entity.setValue(task.date, forKey: "date")
                        print("\(task.days)")
                        do{
                            try ManagedContext.save()
                            }catch{
                                print(error)
                            }
                        print("days: \(task.days)")
                    }
        loadCData()
    }
    
    func loadCData(){
        tasks = [Tasks]()
         //create an instance of app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let ManagedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        
         do{
            
             let results = try ManagedContext.fetch(fetchRequest)
             if results is [NSManagedObject]{
                
                 for result in results as! [NSManagedObject]{
                    
                     let title = result.value(forKey:"title") as! String
                     let days = result.value(forKey: "days") as! Int
                    let date = result.value(forKey: "date") as! String
                    //let counter = result.value(forKey: "counter") as! Int
                    
                    
                    tasks?.append(Tasks(title: title, days: days, date: date))
                    
                 }
             }
         } catch{
             print(error)
         }
         print(tasks!.count )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          
           delegate?.updateText(taskarray: tasks!)
        print("\(tasks!)......")
    
    }
    
    
    
    func clearCData(){
        
    
     //create an instance of app delegate
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
     let ManagedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            
            let results = try ManagedContext.fetch(fetchRequest)
            
        
            for managedObjects in results{
                
                if let managedObjectsData = managedObjects as? NSManagedObject{
                    
                    ManagedContext.delete(managedObjectsData)
                    
                }
            }
        }
            catch{
                print(error)
            }
        
    }
    @IBAction func addingTask(_ sender: UIBarButtonItem) {
    
        let titleT = fields[0].text ?? ""
           let daysD = Int(fields[1].text ?? "0") ?? 0
           let date = NSDate()
        let d_formatter = DateFormatter()
        d_formatter.dateFormat = "EEE, MMM, dd HH:mm:ss"
                   
        let d_string = d_formatter.string(from: date as Date)
        
        let task = Tasks(title: titleT, days: daysD, date: d_string)
        
           tasks?.append(task)
           
                      for textField in fields {
                           textField.text = ""
                          textField.resignFirstResponder()
                      }
           
           print(titleT)
           print(daysD)
           print("Task: \(tasks!)")
                  
    }
}

