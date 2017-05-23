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
  func pointsReceived(_ points: CGPoint)
}

class APIController
{
  var delegate: APIControllerDelegate?
  var point: CGPoint?

  func getPoint()
  {
    let sessionURL = "localhost:8080"
    Alamofire.request(sessionURL).responseJSON { responseData in
      if((responseData.result.value) != nil)
      {
        let pointDictionary = JSON(responseData.result.value!)
        for _ in pointDictionary["points"].arrayValue
        {
          let aPoint = CGPoint(x: 1, y: 1)
          self.point = aPoint
        }
        self.delegate?.pointsReceived(self.point!)
      }
    }
  }
  
  func send(point: CGPoint)
  {

    let sessionURL = "localhost:8080"
    
//    let parameters: [String: Any] = [
//      "":
//    ]
    
    Alamofire.request(
      sessionURL,
      method: .post,
//      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: nil
      ).responseJSON(completionHandler: { responseData in
        debugPrint(responseData)
        
//        if let value = responseData.result.value
//        {
//          let addWatchListDictionary = JSON(value)
//          let addedBool = addWatchListDictionary["watchlist"].boolValue
//          self.watchDelegate?.sendingWatchList(addedBool)
//        }
      })
  }
}




