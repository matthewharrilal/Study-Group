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
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.present(self, animated: true, completion: nil)
        }
        else {
            showMailError()
        }
    }
    
    func configureEmail() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["matthewharrilal@gmail.com"])
        mailComposerVC.setSubject("Regarding Study Group")
        mailComposerVC.setMessageBody("Please Join Us For A Study Group", isHTML: false)
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
