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

protocol APIControllerLineDelegate
{
  func apiControllerDidReceive(lineDictionary: [[String: Any]])
}

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
  
  var lineDelegate: APIControllerLineDelegate?
  var userDelegate: APIControllerUserDelegate?
  var projectDelegate: APIControllerProjectDelegate?
  
  let url = "http://localhost:8080"

  func getLine()
  {
    let sessionURL = "\(url)/getLine"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let lineDictionary = value as! [[String: Any]]
        self.lineDelegate?.apiControllerDidReceive(lineDictionary: lineDictionary)
      }
    }
  }
  
  func getUser()
  {
    let sessionURL = "\(url)/getUser"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let userDictionary = value as! [[String: Any]]
        self.userDelegate?.apiControllerDidReceive(userDictionary: userDictionary)
      }
    }
  }
  
  func getProject()
  {
    let sessionURL = "\(url)/getProject"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let projectDictionary = value as! [[String: Any]]
        self.projectDelegate?.apiControllerDidReceive(projectDictionary: projectDictionary)
      }
    }
  }
  
  func save(line: Line)
  {
    let sessionURL = "\(url)/saveLine"
    let parameters = line.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func save(project: Project)
  {
    let sessionURL = "\(url)/saveProject"
    let parameters = project.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func save(user: User, completionHandler: @escaping APIControllerCompletionHandler)
  {
    let sessionURL = "\(url)/saveUser"
    let parameters = user.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: URLEncoding.httpBody,
      headers: nil
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





