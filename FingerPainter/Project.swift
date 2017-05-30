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
import RealmSwift

class Project: Object
{
  static var current: Project!
  
  dynamic var projectUUID = UUID().uuidString
  dynamic var projectName: String = ""
  dynamic var users: [User] = []
  dynamic var lines: [Line] = []
  
  override class func primaryKey() -> String?
  {
    return "projectUUID"
  }
  
  override class func indexedProperties() -> [String]
  {
    return ["User"]
  }
  
  convenience init(projectUUID: String, users: [User], lines: [Line], projectName: String)
  {
    self.init()
    self.projectUUID = projectUUID
    self.users = users
    self.lines = lines
    self.projectName = projectName
  }
  
  convenience init(json: JSON)
  {
    self.init()
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

class Line: Object
{
  dynamic var start: CGPoint = CGPoint(x: 0, y: 0)
  dynamic var end: CGPoint = CGPoint(x: 0, y: 0)
  dynamic var color: String = ""
  
  convenience init?(start: CGPoint?, end: CGPoint?, color: String?)
  {
    self.init()
    guard let start = start, let end = end, let color = color else { return nil }
    
    self.start = start
    self.end = end
    self.color = color
  }
  
  convenience init(json: JSON)
  {
    self.init()
    start = CGPoint()
    end = CGPoint()
    
    start.x = json["startx"].cgFloatValue
    start.y = json["starty"].cgFloatValue
    end.x = json["endx"].cgFloatValue
    end.y = json["endy"].cgFloatValue
    color = json["color"].stringValue
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
}

extension JSON
{
  var cgFloatValue: CGFloat
  {
    return CGFloat(self.floatValue)
  }
}
