//
//  ApiUserAuthorized.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiUserAuthorized: Mappable{
    var accessToken: String = ""
    var refreshToken: String = ""
    
    init() {}
    
    required public init?(map: Map) {}
    
    func mapping(map: Map) {
        accessToken <- map["jwt"]
        refreshToken <- map["refresh_token"]
    }
}
