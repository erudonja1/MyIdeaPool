//
//  IdeasViewModel.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire


protocol ListOfIdeasViewDelegate: class {
    func logoutSucceeded()
    func fetchedIdeas()
    func deletedIdea()
}

class ListOfIdeasViewModel {

    weak var delegate: ListOfIdeasViewDelegate?
    
    var noMoreResults: Bool = false
    var page: Int = 1
    var ideas: [ApiIdea] = []
    
    func reset() {
        noMoreResults = false
        page = 1
        ideas.removeAll()
    }
    
    func logout(){
        //in case if API fails
        AuthorizationManager.shared.resetAuthorization(authorization: ApiUserAuthorized())
        
        let apiService = BaseApiService()
        let request = apiService.buildRequest(path: "/access-tokens", method: HTTPMethod.delete, encoding: URLEncoding(), params: ["refresh_token": AuthorizationManager.shared.refreshToken])
        apiService.execute(request: request).responseJSON{ _ in
            self.delegate?.logoutSucceeded()
        }
    }
 
    func fetchIdeas() {
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/ideas", method: HTTPMethod.get, encoding: URLEncoding(), params: ["page": page])
        apiService.execute(request: request).responseArray{(response: DataResponse<[ApiIdea]>) in
            if let _ideas = response.value{
                self.ideas.append(contentsOf: _ideas)
                self.delegate?.fetchedIdeas()
                
                if _ideas.isEmpty {
                    self.noMoreResults = true
                }
            }
        }
    }
    
    func fetchNextPage(){
        if noMoreResults == false {
            page = page + 1
            fetchIdeas()
        }
    }
    
    func deleteIdea(id: String) {
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/ideas/\(id)", method: HTTPMethod.delete, encoding: URLEncoding())
        apiService.execute(request: request).responseJSON{ response in
            self.delegate?.deletedIdea()
        }
    }
    
}
