//
//  DisplayStudyGroups.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class DisplayStudyGroups: UITableViewController {
    
    var university: University?
    var dataSource = TableViewDataSource(items: [StudyGroups]())
    
    @objc func addTapped() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addStudyGroupViewController = storyboard.instantiateViewController(withIdentifier: "AddStudyGroupViewController") as! AddStudyGroupViewController
        addStudyGroupViewController.university = self.university
        self.navigationController?.pushViewController(addStudyGroupViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let studyGroups = self.university?.studyGroup?.allObjects as? [StudyGroups] else {return}
        
        dataSource.items = studyGroups
        tableView.dataSource = self.dataSource
        dataSource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let group = studyGroups[indexPath.row]
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = group.studyGroupSubject
            cell?.detailTextLabel?.text = "Meeting at \(group.studyGroupLocation!) at \(group.timeOfStudyGroup!) on \(group.dateOfStudyGroup!)"
            return cell!
        }
        self.tableView.reloadData()
    }
}