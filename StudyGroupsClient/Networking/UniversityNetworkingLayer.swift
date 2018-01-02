//
//  UniversityNetworkingLayer.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/2/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

enum DifferentUniversities {
    // Creating an enum to show the different events that can occur
    case ShowUniversities
}

extension DifferentUniversities: TargetType {
    var baseURL: URL {
        let baseUrl = URL(string: "http://universities.hipolabs.com")
        return baseUrl!
    }
    
    var path: String {
        switch self {
        // For the different case statements accounts for the different endpoints that can occur
        case.ShowUniversities:
            return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ShowUniversities:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .ShowUniversities:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        // Additional data for the network request we are adding parameters
        case .ShowUniversities:
            return .requestParameters(parameters: ["name": "Roanoke"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        // We are not going to need headers in this request therefore we are going to return nil
        return nil
    }
}

func requestUniversities(target: DifferentUniversities, success successCallBack: @escaping (Response)-> Void, error errorCallBack: @escaping (Swift.Error) -> Void, failure failureCallBack: @escaping (MoyaError) -> Void) {
    let provider = MoyaProvider<DifferentUniversities>()
    provider.request(target) { (result) in
        switch result {
        case .success(let response):
            if response.statusCode >= 200 && response.statusCode <= 300{
                // This handles the all the possible succesful requests such as a get request as well as a post request and many others
                successCallBack(response)
            }
        case .failure(let error):
            // This case is executed in the case that there is an error and if there is we are going to call the error call back
            errorCallBack(error)
        }
    }
}
