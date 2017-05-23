//
//  Point.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class Line
{
  var startx: Double
  var starty: Double
  
  var endx: Double
  var endy: Double
  
  init(pointsForLineDictionary: [String: Any])
  {
    startx = pointsForLineDictionary["startx"] as! Double
    starty = pointsForLineDictionary["starty"] as! Double
    
    endx = pointsForLineDictionary["endx"] as! Double
    endy = pointsForLineDictionary["endy"] as! Double
  }
}
