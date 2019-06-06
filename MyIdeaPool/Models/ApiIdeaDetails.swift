//
//  ApiIdea.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiIdeaDetails: Mappable {
    var id: String = ""
    var name: String = ""
    
    required public init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["code"]
        name <- map["name"]
    }
}
