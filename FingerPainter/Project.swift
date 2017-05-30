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
  
  var projectUUID: String
  var name: String
  var users: [User] = []
  var lines: [Line] = []
  
  init(projectUUID: String, users: [User], lines: [Line], name: String)
  {
    self.projectUUID = projectUUID
    self.users = users
    self.lines = lines
    self.name = name
  }
  
  init(json: JSON)
  {
    projectUUID = json["projectUUID"].stringValue
    users = [User(json: json["users"])]
    lines = [Line(json: json["lines"])]
    name = json["name"].stringValue
  }
  
  func postBody() -> [String: Any]
  {
    var projectJsonDictionary = [String: Any]()
    projectJsonDictionary["projectUUID"] = Int(projectUUID)
    projectJsonDictionary["name"] = name
    
    var userDictionaries = [[String: Any]]()
    for aUser in users
    {
      userDictionaries.append(aUser.postBodyForProject())
    }
    projectJsonDictionary["users"] = userDictionaries
    
    var lineDictionaries = [[String: Any]]()
    for aLine in lines
    {
      lineDictionaries.append(aLine.postBody())
    }
    projectJsonDictionary["lines"] = lineDictionaries
    
    return projectJsonDictionary
  }
}

class Line
{
  var start: CGPoint
  var end: CGPoint
  var color: String
  
  init()
  {
    start = CGPoint()
    end = CGPoint()
    color = String()
    
    start.x = 0
    start.y = 0
    end.x = 0
    end.y = 0
    color = "darkGray"
  }
  
  init?(start: CGPoint?, end: CGPoint?, color: String?)
  {
    guard let start = start, let end = end, let color = color else { return nil }
    
    self.start = start
    self.end = end
    self.color = color
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "startx": start.x,
      "starty": start.y,
      "endx": end.x,
      "endy": end.y,
      "color": color
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
    color = json["color"].stringValue
  }
}

extension JSON
{
  var cgFloatValue: CGFloat
  {
    return CGFloat(self.floatValue)
  }
}
