//
//  Project.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/24/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreGraphics

class Project
{
  static var current: Project!
  
  var id: Int = 0
  var projectName: String = ""
  var user1Id: Int = 0
  var user2Id: Int = 0
  var lines: [Line] = []
  
  init(user1Id: Int, lines: [Line], projectName: String)
  {
    self.id = 0
    self.user1Id = user1Id
    self.user2Id = 0
    self.lines = lines
    self.projectName = projectName
  }
  
  init(json: JSON)
  {
    id = json["id"].intValue
    user1Id = json["user1Id"].intValue
    user2Id = json["user2Id"].intValue
    lines = [Line(json: json["lines"])]
    projectName = json["projectName"].stringValue
  }
  
  func postBody() -> [String: Any]
  {
    var projectJsonDictionary = [String: Any]()
    projectJsonDictionary["id"] = id
    projectJsonDictionary["projectName"] = projectName
    projectJsonDictionary["user1Id"] = user1Id
    projectJsonDictionary["user2Id"] = user2Id
    
    let lineDictionaries = lines.map{ $0.postBody()}
    projectJsonDictionary["lines"] = lineDictionaries
    
    return projectJsonDictionary
  }
}

class Line
{
  var id: Int = 0
  var projectId: Int = 0
  var startx: Double = 0
  var starty: Double = 0
  var endx: Double = 0
  var endy: Double = 0
  var color: String = ""
  var thickness: Double = 0
  
  init?(projectId: Int, startx: Double, starty: Double, endx: Double, endy: Double, color: String?, thickness: Double)
  {
    guard let color = color else { return nil }
    
    self.id = 0
    self.projectId = projectId
    self.startx = startx
    self.starty = starty
    self.endx = endx
    self.endy = endy
    self.color = color
    self.thickness = thickness
  }
  
  init(json: JSON)
  {
    startx = Double(json["startx"].floatValue)
    starty = Double(json["starty"].floatValue)
    endx = Double(json["endx"].floatValue)
    endy = Double(json["endy"].floatValue)
    color = json["color"].stringValue
    thickness = Double(json["thickness"].floatValue)
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "startx": startx,
      "starty": starty,
      "endx": endx,
      "endy": endy,
      "color": color
    ]
  }
}

extension JSON
{
  var cgFloatValue: CGFloat
  {
    return CGFloat(self.floatValue)
  }
}
