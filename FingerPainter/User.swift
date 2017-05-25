//
//  User.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/24/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import SwiftyJSON

class User
{
  var userId: String
  var username: String
  var password: String
  
  init()
  {
    self.userId = ""
    self.username = ""
    self.password = ""
  }
  
  init(userId: String, username: String, password: String)
  {
    self.userId = userId
    self.username = username
    self.password = password
  }
  
  init(json: JSON)
  {
    userId = json["userId"].stringValue
    username = json["username"].stringValue
    password = json["password"].stringValue
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "userId": userId,
      "username": username,
      "password": password,
    ]
  }
}
