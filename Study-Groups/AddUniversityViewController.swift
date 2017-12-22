//
//  AddUniversityViewController.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddUniversityViewController: UIViewController {
    
    @IBOutlet weak var addUniversityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addUniversityButton(_ sender: UIButton) {
        // Grab the name of the university that the user passes in
        guard let universityName = addUniversityTextField.text else {return}
        
        // Accesses the view context
        let viewContext = CoreDataStack.singletonInstance.viewContext
        // Make an instance of the university
        let university = University(context: viewContext)
        
        // Set that value in core data then save that value and then go back to that view controller
        university.setValue(universityName, forKey: "nameOfUniversity")
        CoreDataStack.singletonInstance.saveTo(context: viewContext)
        self.navigationController?.popViewController(animated: true)
    }
    
}
