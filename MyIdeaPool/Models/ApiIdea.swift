//
//  ApiIdeaList.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiIdea: Mappable {
    var id: String = ""
    var content: String = ""
    var impact: Int = 0
    var ease: Int = 0
    var confidence: Int = 0
    var averageScore: Double = 0.0
    var createdAt: Int = 0
    
    required public init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        impact <- map["impact"]
        ease <- map["ease"]
        confidence <- map["confidence"]
        averageScore <- map["average_score"]
        createdAt <- map["created_at"]
    }
}
