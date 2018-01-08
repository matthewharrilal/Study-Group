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

    // The Target Type is a bunch of protocols that we conform to so that it can formulate the network request
    var baseURL: URL {
        let baseUrl = URL(string: "http://127.0.0.1:5000")
        return baseUrl!
    }
    
    // Defines the path for different case statements or different endpoints
    var path: String {
        switch self {
        case .showUsers, .createUsers:
            return "/users"
        }
    
    }
    
    // What type of http method should be used on different case statements
    var method: Moya.Method {
        switch self {
        case .showUsers:
            return .get
        case .createUsers:
            return .post
        }
    }
    
    
    // If there is data that we want to use for testing but if we were creating a user then what we do is that we create the data znd encode it so that we can send it over to the server and then send it to the database
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
    
    // This handles if there is any extra components needed for the network request such as parameters
    var task: Task {
        switch self {
        case .showUsers, .createUsers:
            return .requestPlain
        }
    }
    
    // Handles the headers if there are any in the network request
    var headers: [String : String]? {
        let user: User? = nil
        switch self {
        case .createUsers, .showUsers:
            // Put some logic in this task
            return ["Authorization": (user?.credential)!]
        }
    }
    
    // This function we have to do through the provider all the requests are made through this class
    // The parameters that are needed for this function are the target what data are we using to make this network request
    // The success callback is called after the lifetime of the function ends as well as the error callback and the failure callback are error handline
    func userNetworking(target: DifferentUsers, success successCallBack: @escaping (Response) -> Void, error errorCallBack: @escaping(Swift.Error) -> Void, failure failureCallBack: @escaping (MoyaError) -> Void) {
        let provider = MoyaProvider<DifferentUsers>()
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    // This function is going to end the lifetime before the response is done being completed therefore by making it escaping we can have the response come back at a later time
                    successCallBack(response)
                }
            case .failure(let error):
                // If there is a failure then what we can do is that we can be able to see if there is an error and get the response back from the error
                errorCallBack(error)
            }
        }
    }
    
    
}
