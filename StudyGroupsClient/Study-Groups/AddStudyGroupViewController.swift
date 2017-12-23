//
//  AddStudyGroupViewController.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddStudyGroupViewController: UIViewController {
    var university: University?
    
    @IBOutlet weak var nameOfSubjectTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is the university that the user has chosen \(self.university?.nameOfUniversity)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let subjectName = nameOfSubjectTextField.text,
        let date = dateTextField.text,
        let time = timeTextField.text,
        let location = locationTextField.text
            else {return}
        let viewContext = CoreDataStack.singletonInstance.viewContext
        let studyGroup = StudyGroups(context: viewContext)

        // Setting the values in core data for the keys for the study group entity the  saving the changes once we add the study group to the specific courses entity
        studyGroup.setValue(date, forKey: "dateOfStudyGroup")
        studyGroup.setValue(subjectName, forKey: "studyGroupSubject")
        studyGroup.setValue(location, forKey: "studyGroupLocation")
        studyGroup.setValue(time, forKey: "timeOfStudyGroup")
        self.university?.addToStudyGroup(studyGroup)
        CoreDataStack.singletonInstance.saveTo(context: viewContext)
        self.navigationController?.popViewController(animated: true)
    }
    
}
