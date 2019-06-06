//
//  ApiUserTokenRefreshed.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiUserTokenRefreshed: Mappable{
    var access_token: String = ""
    
    init() {}
    
    required public init?(map: Map) {}
    
    func mapping(map: Map) {
        access_token <- map["jwt"]
    }
}
