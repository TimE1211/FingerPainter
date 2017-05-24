//
//  User.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/24/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation

class User
{
  var id: Int
  var username: String
  
  init()
  {
    self.id = 0
    self.username = ""
  }
  
  init(id: Int, username: String)
  {
    self.id = id
    self.username = username
  }
}
