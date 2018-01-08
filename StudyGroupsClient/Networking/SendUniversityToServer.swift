//
//  SendUniversityToServer.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/8/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

enum SendingOfUniversity {
    case sendUniversity
}

extension SendingOfUniversity: TargetType {
    var baseURL: URL {
        // The Target Type is a bunch of protocols that we conform to so that it can formulate the network request
        var baseURL: URL {
            let baseUrl = URL(string: "http://127.0.0.1:5000")
            return baseUrl!
        }
    }
    
    var path: String {
        switch self {
        case .sendUniversity:
            return "/university"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendUniversity:
            return .post
        }
    }
    
    var sampleData: Data {
        
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}
