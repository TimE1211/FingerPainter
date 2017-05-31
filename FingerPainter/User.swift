//
//  User.swift
//  
//
//  Created by Timothy Hang on 5/25/17.
//
//

import Foundation
import SwiftyJSON

class User
{
  static var current: User!
  
  var username = ""
  var password = ""
  
  init(username: String, password: String)
  {
    self.username = username
    self.password = password
  }
  
  init(json: JSON)
  {
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
}




