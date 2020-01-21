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
        saveCData()
        loadCData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveCData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func saveCData(){
       // call clear core data
        clearCData()
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let ManagedContext = appDelegate.persistentContainer.viewContext
               
                    for task in tasks!{
                        let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "Model", into: ManagedContext)
                        taskEntity.setValue(task.title, forKey: "title")
                        taskEntity.setValue(task.days, forKey: "days")
               
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
                     tasks?.append(Tasks(title: title, days: days))
                    
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
                      
                   
           let task = Tasks(title: titleT, days: daysD)
        
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

