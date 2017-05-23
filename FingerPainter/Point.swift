//
//  Point.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class Point
{
  var x: Double
  var y: Double
  
  init(pointDictionary: [String: Any])
  {
    x = pointDictionary["x"] as! Double
    y = pointDictionary["y"] as! Double
  }
}
