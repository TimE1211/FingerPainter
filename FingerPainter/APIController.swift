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
  var points: CGPoint?

  func getPoints()
  {
    let sessionURL = "localhost:8080"
    Alamofire.request(sessionURL).responseJSON { responseData in
      if((responseData.result.value) != nil)
      {
        let pointDictionary = JSON(responseData.result.value!)
        for aPointJson in pointDictionary["points"].arrayValue
        {
          let aPoint = CGPoint(x: xValue, y: yValue)
          self.points.append(aPoint)
        }
        self.delegate?.pointsReceived(self.points!)
      }
    }
  }
}




