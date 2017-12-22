//
//  ComposeEmailViewController.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/22/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ComposeEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var university: University?
    var studyGroup: StudyGroups?
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("THIS IS THE UNIVERSITY \(self.university?.nameOfUniversity)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func sendEmailButton(_ sender: UIButton) {
        let mailComposeViewController = configureEmail()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showMailError()
        }
    }
    
    func configureEmail() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let studygroups = DisplayStudyGroups()
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("Regarding Upcoming Study Group")
        mailComposerVC.setMessageBody("There is an upcoming study group occuring at \(self.university!.nameOfUniversity!) and you're invited! This study group is taking place at \(self.studyGroup!.studyGroupLocation!) at \(self.studyGroup!.timeOfStudyGroup!) on \(self.studyGroup!.dateOfStudyGroup). Be prepared to bring the supplies neccesary to succeed!", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please try sending the email again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        sendMailErrorAlert.addAction(cancelAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
