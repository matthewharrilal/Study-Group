//
//  UserNetworkingLayer.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/8/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

enum DifferentUsers {
    case showUsers
    case createUsers
}

extension DifferentUsers: TargetType {
    var baseURL: URL {
        let baseUrl = URL(string: "http://127.0.0.1:5000")
        return baseUrl!
    }
    
    var path: String {
        switch self {
        case .showUsers, .createUsers:
            return "/users"
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .showUsers:
            return .get
        case .createUsers:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .showUsers:
            return Data()
        case .createUsers:
            var jsonBody = Data()
            let user: User? = nil
            do {
                jsonBody = try! JSONEncoder().encode(user)
            }
            catch {
                print("Unresolved Error")
            }
            return jsonBody
        }
    }
    
    var task: Task {
        switch self {
        case .showUsers, .createUsers:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createUsers, .showUsers:
            return 
        }
    }
    
    
}
