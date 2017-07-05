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
  
//  let url = "http://localhost:8080"
  let url = "http://timothys-macbook-pro.local:8080"
  
  func save(user: User, completionHandler: @escaping APIControllerCompletionHandler)
  {
    let sessionURL = "\(url)/saveUser"
    let parameters = user.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: self.encoding(.post),
      headers: ["Content-Type": "application/json"]
      ).validate(statusCode: 200...200).responseJSON(completionHandler: { responseData in
        //        debugPrint(responseData)
        
        if let result = responseData.result.value {
          completionHandler(JSON(result), nil)
        } else if let error = responseData.result.error {
          completionHandler(nil, JSON(error))
        }
      })
  }
  
  func getUsers()
  {
    let sessionURL = "\(url)/getUsers"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      
      print(responseData)
      
      if let value = responseData.result.value
      {
        let userDictionary = value as! [[String: Any]]
        self.userDelegate?.apiControllerDidReceive(userDictionary: userDictionary)
      }
    }
  }
  
  func getProjects(completionHandler: APIControllerCompletionHandler? = nil)
  {
    let sessionURL = "\(url)/getProjects"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let projectDictionary = value as! [[String: Any]]
        self.projectDelegate?.apiControllerDidReceive(projectDictionary: projectDictionary)
        completionHandler?(JSON(value), nil)
      } else if let error = responseData.result.error {
        completionHandler?(nil, JSON(error))
      } else {
        completionHandler?(nil, nil)
      }
    }
  }
  
  func getAProject(projectId: Int, completionHandler: APIControllerCompletionHandler? = nil)
  {
    var projectJsonDictionary = [String: Any]()
    projectJsonDictionary["id"] = projectId
    
    let sessionURL = "\(url)/getAProject"
    let parameters = projectJsonDictionary
    
//    print(parameters)
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: self.encoding(.post),
      headers: ["Content-Type": "application/json"]
      ).responseJSON(completionHandler: { responseData in
        if let value = responseData.result.value
        {
          let projectDictionary = value as! [[String: Any]]
          self.projectDelegate?.apiControllerDidReceive(projectDictionary: projectDictionary)
          completionHandler?(JSON(value), nil)
        } else if let error = responseData.result.error {
          completionHandler?(nil, JSON(error))
        } else {
          completionHandler?(nil, nil)
        }
      })
  }

  func create(project: Project, completionHandler: @escaping APIControllerCompletionHandler)
  {
    let sessionURL = "\(url)/createProject"
    let parameters = project.postBody()
    
    print(parameters)
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: self.encoding(.post),
      headers: ["Content-Type": "application/json"]
      ).validate(statusCode: 200...200).responseJSON(completionHandler: { responseData in
//        debugPrint(responseData)
        
        if let result = responseData.result.value {
          completionHandler(JSON(result), nil)
        } else if let error = responseData.result.error {
          completionHandler(nil, JSON(error))
        }
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
      encoding: self.encoding(.post),
      headers: ["Content-Type": "application/json"]
      ).responseJSON(completionHandler: { responseData in
//        debugPrint(responseData)
      })
  }
  
  func encoding(_ method: HTTPMethod) -> ParameterEncoding {
    return method == .get ? URLEncoding.default : JSONEncoding.default
  }
}

