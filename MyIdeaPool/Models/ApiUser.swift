//
//  ApiUser.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiUser: Mappable {
    var email: String = ""
    var name: String = ""
    var avatarUrl: String = ""
    
    required public init?(map: Map) {}
    
    func mapping(map: Map) {
        avatarUrl <- map["avatar_url"]
        email <- map["email"]
        name <- map["name"]
    }
}


