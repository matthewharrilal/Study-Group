//
//  UniversityModelingLayer.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 1/2/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire

struct UniversityInformation {
    let name: String
    let webPage: String
    let country:String
    let domain: String
    init(name: String, webPage: String, country: String, domain: String) {
        self.name = name
        self.webPage = webPage
        self.country = country
        self.domain = domain
    }
}

enum DifferentHttpMethods: String {
    case get = "GET"
}

extension UniversityInformation : Decodable{
    enum FirstLayerKeys: String, CodingKey {
        case name
        case webPage = "web_page"
        case country
        case domain
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirstLayerKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let webPage = try container.decodeIfPresent(String.self, forKey: .webPage)
        let country = try container.decodeIfPresent(String.self, forKey: .country)
        let domain = try container.decodeIfPresent(String.self, forKey: .domain)
        self.init(name: name!, webPage: webPage!, country: country!, domain: domain!)
    }
}
