//
//  UpdateIdeaViewModel.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire

protocol UpdateIdeaViewDelegate: class {
    func saveSucceeded()
    func saveFailed(error: Error)
}

class UpdateIdeaViewModel {
    weak var delegate: UpdateIdeaViewDelegate?
    var idea: ApiIdea?
    
    func save(content: String, impact: Int, ease: Int, confidence: Int){
        // if the model has an id, it means that this will be an update for it
        if let id = idea?.id {
            updateIdea(id: id, content: content, impact: impact, ease: ease, confidence: confidence)
            return
        }
        
        createIdea(content: content, impact: impact, ease: ease, confidence: confidence)
    }
    private func createIdea(content: String, impact: Int, ease: Int, confidence: Int){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/ideas", method: HTTPMethod.post, encoding: JSONEncoding(), params: ["content": content, "impact": impact, "ease": ease, "confidence": confidence])
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiIdea>) in
            
            if let _error = response.error{
                self.delegate?.saveFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                self.delegate?.saveFailed(error: _error)
                return
            }
            
            if let _ = response.value{
                self.delegate?.saveSucceeded()
            }
        }
    }
    
    private func updateIdea(id: String, content: String, impact: Int, ease: Int, confidence: Int){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/ideas/\(id)", method: HTTPMethod.put, encoding: JSONEncoding(), params: ["content": content, "impact": impact, "ease": ease, "confidence": confidence])
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiIdea>) in
            
            if let _error = response.error{
                self.delegate?.saveFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                self.delegate?.saveFailed(error: _error)
                return
            }
            
            if let _ = response.value{
                self.delegate?.saveSucceeded()
            }
        }
    }
    
}
