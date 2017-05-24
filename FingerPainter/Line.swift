//
//  Point.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftyJSON

class Line
{
  var start: CGPoint
  var end: CGPoint
  
  init?(start: CGPoint?, end: CGPoint?)
  {
    guard let start = start, let end = end else { return nil }
    
    self.start = start
    self.end = end
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "startx": start.x,
      "starty": start.y,
      "endx": end.x,
      "endy": end.y
    ]
  }
  
  
  init(json: JSON)
  {
    start = CGPoint()
    end = CGPoint()
      
    start.x = json["startx"].cgFloatValue
    start.y = json["starty"].cgFloatValue
    
    end.x = json["endx"].cgFloatValue
    end.y = json["endy"].cgFloatValue
  }
}

extension JSON
{
  var cgFloatValue: CGFloat
  {
    return CGFloat(self.floatValue)
  }
}
