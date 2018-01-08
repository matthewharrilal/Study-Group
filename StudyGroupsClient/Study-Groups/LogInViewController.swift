//
//  LogInViewController.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/8/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
        let password = passwordTextField.text
            else {return}
        
        EmailAndPassword.email = email
        EmailAndPassword.password = password
        
        userNetworking(target: .showUsers, success: { (response) in
            print("This is the response \(try? response.mapJSON())")
        }, error: { (error) in
            print("This is the error \(error.localizedDescription)")
        }) { (moyaError) in
            print("This is the moya error \(moyaError.errorDescription), and the reason being \(moyaError.failureReason)")
        }
    }
    
}
