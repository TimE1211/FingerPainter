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

protocol APIControllerLineDelegate
{
  func apiControllerDidReceive(lineDictionary: [[String: Any]])
}

protocol APIControllerUserDelegate
{
  func apiControllerDidReceive(userDictionary: [String: Any])
}

class APIController
{
  static let shared = APIController()
  
  var lineDelegate: APIControllerLineDelegate?
  var userDelegate: APIControllerUserDelegate?
  var line: Line?
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
  
  func send(line: Line)
  {
    let sessionURL = "\(url)/sendLine"
    let parameters = line.postBody()
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
//      encoding: JSONEncoding.default,
      encoding: URLEncoding.httpBody,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func send(project: Project)
  {
    let sessionURL = "\(url)/sendProject"
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

  func getUserData()
  {
    let sessionURL = "\(url)/userData"
    
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let userDictionary = value as! [String: Any]
        self.userDelegate?.apiControllerDidReceive(userDictionary: userDictionary)
      }
    }
  }
}





