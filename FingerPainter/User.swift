//
//  User.swift
//  
//
//  Created by Timothy Hang on 5/25/17.
//
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object
{
  static var current: User!
  
  dynamic var username = ""
  dynamic var password = ""
  
  override class func primaryKey() -> String?
  {
    return "username"
  }
  
  override class func indexedProperties() -> [String]
  {
    return ["username"]
  }
  
  convenience init(username: String, password: String)
  {
    self.init()
    self.username = username
    self.password = password
  }
  
  convenience init(json: JSON)
  {
    self.init()
    username = json["username"].stringValue
    password = json["password"].stringValue
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "username": username,
      "password": password,
    ]
  }
  
  func postBodyForProject() -> [String: Any]
  {
    return [
      "username": username,
    ]
  }
}




