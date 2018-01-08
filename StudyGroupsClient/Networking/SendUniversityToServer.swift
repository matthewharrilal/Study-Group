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
    
    // The Target Type is a bunch of protocols that we conform to so that it can formulate the network request
    var baseURL: URL {
        let baseUrl = URL(string: "http://127.0.0.1:5000")
        return baseUrl!
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
        return Data()
    }
    
    var parameters: [String: String]? {
        switch self {
        case .sendUniversity:
            return ["university_name": "Harvard"]
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .sendUniversity:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .sendUniversity:
            
           return .requestData(sampleData)
        }
    }
    
    var headers: [String : String]? {
        let user = User(email: "larry@gmail.com", password: "larry")
        switch self {
        case .sendUniversity:
            return ["Authorization": (user.credential)!]
        }
    }
    
}

func sendUniversityToServer(target: SendingOfUniversity, success successCallBack: @escaping (Response) -> Void, error errorCallBack: @escaping(Swift.Error)-> Void, moyaError : @escaping (MoyaError) -> Void) {
    let provider = MoyaProvider<SendingOfUniversity>()
    provider.request(target) { (result) in
        switch result {
        case .success(let response):
            if response.statusCode >= 200 && response.statusCode <= 300 {
                // This function is going to end the lifetime before the response is done being completed therefore by making it escaping we can have the response come back at a later time
                print("The response was correct")
                successCallBack(response)
            }
        case .failure(let error):
            // If there is a failure then what we can do is that we can be able to see if there is an error and get the response back from the error
            errorCallBack(error)
        }
    }
}
