//
//  APIController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/22/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias APIControllerCompletionHandler = (_ result: JSON?, _ error: JSON?) -> Void

protocol APIControllerUserDelegate
{
  func apiControllerDidReceive(userDictionary: [[String: Any]])
}

protocol APIControllerProjectDelegate
{
  func apiControllerDidReceive(projectDictionary: [[String: Any]])
}

class APIController
{
  static let shared = APIController()
  
  var userDelegate: APIControllerUserDelegate?
  var projectDelegate: APIControllerProjectDelegate?
  
  let url = "http://localhost:8080"
  
  func getUsers()
  {
    let sessionURL = "\(url)/getUsers"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let userDictionary = value as! [[String: Any]]
        self.userDelegate?.apiControllerDidReceive(userDictionary: userDictionary)
      }
    }
  }
  
  func getProjects()
  {
    let sessionURL = "\(url)/getProjects"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let projectDictionary = value as! [[String: Any]]
        self.projectDelegate?.apiControllerDidReceive(projectDictionary: projectDictionary)
      }
    }
  }

  func create(project: Project)
  {
    let sessionURL = "\(url)/createProject"
    let parameters = project.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: ["Content-Type": "application/json"]
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func update(project: Project)
  {
    let sessionURL = "\(url)/updateProject"
    let parameters = project.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: ["Content-Type": "application/json"]
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func create(user: User, completionHandler: @escaping APIControllerCompletionHandler)
  {
    let sessionURL = "\(url)/createUser"
    let parameters = user.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: ["Content-Type": "application/json"]
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
        
        if let result = responseData.result.value {
          completionHandler(JSON(result), nil)
        } else if let error = responseData.result.error {
          completionHandler(nil, JSON(error))
        }
      })
  }
}





