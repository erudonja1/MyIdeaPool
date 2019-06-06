//
//  BaseConfiguration.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation


import Foundation

protocol ApiConfiguration: class {
    var url: String { get set }
}

class BaseConfiguration: ApiConfiguration {
    var url: String
    static let shared: BaseConfiguration = BaseConfiguration()
    
    init() {
        //this could be set (later on) to be built at runtime from .plist
        self.url = "https://small-project-api.herokuapp.com"
    }
}
