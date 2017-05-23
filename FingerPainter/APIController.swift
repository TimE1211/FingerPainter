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

protocol APIControllerDelegate
{
  func apiControllerDidReceive(endPointDictionary: [String: Any])
  func apiControllerDidReceive(startPointDictionary: [String: Any])
}

class APIController
{
  var delegate: APIControllerDelegate?
  var point: CGPoint?
  let url = "localhost:8080"

  func getStartingPoint()
  {
    let sessionURL = "\(url)/getStartingPoint"
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let pointDictionary = value as! [String: Any]
        self.delegate?.apiControllerDidReceive(startPointDictionary: pointDictionary)
      }
    }
  }
  
  func getEndingPoint()
  {
    let sessionURL = "\(url)/getEndingPoint"
    Alamofire.request(sessionURL).responseJSON { responseData in
      if let value = responseData.result.value
      {
        let pointDictionary = value as! [String: Any]
        self.delegate?.apiControllerDidReceive(endPointDictionary: pointDictionary)
      }
    }
  }
  
  func send(startingPoint: CGPoint)
  {
    let sessionURL = "\(url)/saveStartingPoint"
    
    let parameters: [String: Any] = [
      "x": point!.x,
      "y": point!.y
    ]
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
  
  func send(endingPoint: CGPoint)
  {
    let sessionURL = "\(url)/saveEndingPoint"
    
    let parameters: [String: Any] = [
      "x": point!.x,
      "y": point!.y
    ]
    
    Alamofire.request(
      sessionURL,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
      })
  }
}




