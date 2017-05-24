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
  let id: Int
  let username: String
  let name: String
  
  init(id: Int, username: String, name: String)
  {
    self.id = id
    self.username = username
    self.name = name
  }
}
