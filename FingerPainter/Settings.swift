//
//  Settings.swift
//  FingerPainter
//
//  Created by Timothy Hang on 6/1/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import Foundation
import UIKit

enum ColorOption: String
{
  case red
  case green
  case blue
  case yellow
  case black
  case white
  
  static var all: [ColorOption]
  {
    return [.red, .green, .blue, .yellow, .black, .white]
  }
}

extension UIColor
{
  static func from(colorOption: ColorOption) -> UIColor
  {
    switch colorOption {
    case .red: return .red
    case .green: return .green
    case .blue: return .blue
    case .yellow: return .yellow
    case .black: return .black
    case .white: return .white
    }
  }
}

private let kLineColor = "com.drawntogether.keys.lineColor"
private let kLineWidth = "com.drawntogether.keys.lineWidth"

extension UserDefaults
{
  func set(_ color: UIColor, forKey key: String)
  {
    let data = NSKeyedArchiver.archivedData(withRootObject: color)
    set(data, forKey: key)
  }
  
  func color(forKey key: String) -> UIColor?
  {
    guard let data = object(forKey: key) as? Data else { return nil }
    return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
  }
}

class Settings
{
  static var shared = Settings()
  
  var lineColor: ColorOption
  {
    get {
      
      let saved = UserDefaults.standard.string(forKey: kLineColor) ?? "black"
      return ColorOption(rawValue: saved) ?? .black
      
    }
    set { UserDefaults.standard.set(newValue.rawValue, forKey: kLineColor) }
  }
  
  var lineWidth: Double
  {
    get {
      let saved = UserDefaults.standard.double(forKey: kLineWidth)
      return saved == 0 ? 5 : saved
    }
    set { UserDefaults.standard.set(newValue, forKey: kLineWidth) }
  }
}

