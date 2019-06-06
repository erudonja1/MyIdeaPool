//
//  BaseNetworkService.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class BaseApiService {
    
    var config: ApiConfiguration
    
    init() {
        self.config = BaseConfiguration.shared
    }
    
    func execute(request: URLRequest) -> DataRequest {
        return ApiManager.shared.request(request).validate()
    }
    
    func buildRequest(path: String, method: HTTPMethod, encoding: ParameterEncoding, params: Parameters? = nil) -> URLRequest {
        let url = createUrl(config.url)
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        do {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }  catch _ {
            print("Failed encoding of params")
        }
        return urlRequest
    }
    
    private func createUrl(_ fromUrl: String) -> URL{
        if let _url = URL(string: fromUrl){
            return _url
        }
        return URL(fileURLWithPath: "")
    }
}
