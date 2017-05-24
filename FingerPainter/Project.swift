//
//  Project.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/24/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class Project
{
  var id: UUID
  var name: String
  var users: [User] = []
  var lines: [Line] = []
  
  init(id: UUID, users: [User], lines: [Line], name: String)
  {
    self.id = id
    self.users = users
    self.lines = lines
    self.name = name
  }
  
  func postBody() -> [String: Any]
  {
    return [
      "id": id,
      "name": name,
      "users": users,
      "lines": lines
    ]
  }
}
