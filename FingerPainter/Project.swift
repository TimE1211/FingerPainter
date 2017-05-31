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
  
  var projectUUID = UUID().uuidString
  var projectName: String = ""
  var users: [User] = []
  var lines: [Line] = []
  
  init(projectUUID: String, users: [User], lines: [Line], projectName: String)
  {
    self.projectUUID = projectUUID
    self.users = users
    self.lines = lines
    self.projectName = projectName
  }
  
  init(json: JSON)
  {
    projectUUID = json["projectUUID"].stringValue
    users = [User(json: json["users"])]
    lines = [Line(json: json["lines"])]
    projectName = json["projectName"].stringValue
  }
  
  func postBody() -> [String: Any]
  {
    var projectJsonDictionary = [String: Any]()
    projectJsonDictionary["projectUUID"] = Int(projectUUID)
    projectJsonDictionary["projectName"] = projectName
    
    var userDictionaries = [[String: Any]]()
    for aUser in users
    {
      userDictionaries.append(aUser.postBody())
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
  var startx: Double = 0
  var starty: Double = 0
  var endx: Double = 0
  var endy: Double = 0
  var color: String = ""
  var thickness: Double = 0
  
  init?(startx: Double, starty: Double, endx: Double, endy: Double, color: String?, thickness: Double)
  {
    guard let color = color else { return nil }
    
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
