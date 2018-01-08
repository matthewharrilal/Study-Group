//
//  UserModelingLayer.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/8/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class User: Codable {
    var email: String?
    var password: String?
    var credential: String?
    init(email: String?, password: String?) {
        
        self.email = email
        self.password = password
        // Stores the headers as a credential that we can keep passing around because the way our server is built we are constantly verifying if the user is logged in or not so if we have the headers stored as a credential we can keep verifying if the user is verified or not
        self.credential = BasicAuth.generateBasicAuthHeader(username: self.email!, password: self.password!)
    }
    
    enum FirstLayerKeys: String, CodingKey {
        case email
        case password
    }
    
    required convenience init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: FirstLayerKeys.self)
        let email = try? container?.decodeIfPresent(String.self, forKey: .email)
        let password = try? container?.decodeIfPresent(String.self, forKey: .password)
        self.init(email: email!, password: password!)
    }
}




