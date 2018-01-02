//
//  DisplayUniversitiesViewController.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DisplayUniversitiesViewController: UITableViewController {
    
    
    var dataSource = TableViewDataSource(items: [University]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let fetch = fetchRequest(namOfEntity: "University", type: University.self)
        print("this is the fetch \(fetch)")
        self.dataSource.items = fetch!
        tableView.dataSource = self.dataSource
        dataSource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let university = self.dataSource.items[indexPath.row]
            cell?.textLabel?.text = university.nameOfUniversity
            return cell!
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let displayStudyGroups = storyboard.instantiateViewController(withIdentifier: "DisplayStudyGroups") as! DisplayStudyGroups
        let university = self.dataSource.items[indexPath.row]
        displayStudyGroups.university = university
        self.navigationController?.pushViewController(displayStudyGroups, animated: true)
    }
}
