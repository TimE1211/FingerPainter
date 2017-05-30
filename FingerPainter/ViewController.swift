//
//  ViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/15/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

//from a tutorial ben gave me
//https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import UIKit
import SwiftyJSON
//import RealmSwift

enum DrawingStatus
{
  case started
  case drawing
  case ended
  case none
}

class ViewController: UIViewController
{
  @IBOutlet weak var canvas: UIImageView!
  
  var start: CGPoint?
  var end: CGPoint?
  var color: String?
  
  var users = [User]()
  var password = String()
  var projectName = String()
  var projectUUID = String()
  
  var lines = [Line]()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    APIController.shared.lineDelegate = self
    setColor()
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  func setColor()
  {
    color = "darkGray"
    //or color = "white"
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first
    {
      start = touch.location(in: view)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first
    {
      end = touch.location(in: view)
      
      if let start = start
      {
        drawFromPoint(start: start, toPoint: end!, with: color!)
      }
      if let line = Line(start: start, end: end, color: color)
      {
        APIController.shared.save(line: line)
      }
      self.start = end
    }
  }
  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//  {
//    status = .ended
//  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint, with color: String)
  {
    UIGraphicsBeginImageContext(canvas.frame.size)
    if let context = UIGraphicsGetCurrentContext()
    {
      canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
      if color == "darkGray"
      {
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(5)
      }
      else if color == "white"
      {
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(15)
      }
      context.beginPath()
      context.move(to: CGPoint(x: start.x, y: start.y))
      context.addLine(to: CGPoint(x: end.x, y: end.y))
      context.strokePath()
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      canvas.image = newImage
    }
  }
  
  @IBAction func clearTapped(_ sender: UIBarButtonItem)
  {
    canvas.image = nil
  }
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem)
  {
    let thisProject = Project(projectUUID: projectUUID, users: users, lines: lines, name: projectName)
    APIController.shared.save(project: thisProject)
  }
  
  @IBAction func UpdateTapped(_ sender: UIBarButtonItem)
  {
    APIController.shared.getLines()
  }
}

extension ViewController: APIControllerLineDelegate
{
  func apiControllerDidReceive(lineDictionary: [[String : Any]])
  {
    for aLine in lineDictionary
    {
      let line = Line(json: JSON(aLine))
      let startPoint = CGPoint(x: line.start.x, y: line.start.y)
      let endPoint = CGPoint(x: line.end.x, y: line.end.y)
      lines.append(line)
      drawFromPoint(start: startPoint, toPoint: endPoint, with: line.color)
      self.start = endPoint
    }
  }
}









