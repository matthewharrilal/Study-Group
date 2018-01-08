//
//  BasicAuth.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/8/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

struct BasicAuth {
    // What this struct essentially does is that it allows us to encode the authentication headers  in base 64 for us so this is basically the sanitization part of our code for us and what we are doing to get there
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        //Formatting the code we get from the headers into base 64 so then we can get the sanatized form of the headers and then from there we can use these to verify evertime the user wants to log in becuase this  works in tandem with our networking code from the user
        let loginString = String(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        
        return authHeaderString
    }
}
