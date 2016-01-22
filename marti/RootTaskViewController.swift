//
//  RootTaskViewController.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-27.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import UIKit
import CoreData

class RootTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let fetchedResultsController = MartiCDManager.sharedInstance.rootTaskFetchedResultController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section] 
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RootTaskCell", forIndexPath: indexPath) 
        let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.description
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section] 
            return currentSection.name
        }
        
        return nil
    }
    
}