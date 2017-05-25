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
  
  var user = [User]()
  var password = String()
  var projectName = String()
  var projectUUID = String()
  
  var lines = [Line]()
  
//  var status: DrawingStatus = .none
//  {
//    didSet {
//      if status == .ended, let line = Line(start: start, end: end)
//      {
////        APIController.shared.send(line: line)
//        status = .none
//      }
//    }
//  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    APIController.shared.lineDelegate = self
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first
    {
      start = touch.location(in: view)
//      status = .started
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
//    status = .drawing
    if let touch = touches.first
    {
      end = touch.location(in: view)
      
      if let start = start
      {
        drawFromPoint(start: start, toPoint: end!)
      }
      if let line = Line(start: start, end: end)
      {
        APIController.shared.send(line: line)
      }
      self.start = end
    }
  }
  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//  {
//    status = .ended
//  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint)
  {
    UIGraphicsBeginImageContext(canvas.frame.size)
    if let context = UIGraphicsGetCurrentContext()
    {
      canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
      context.setLineWidth(5)
      context.setStrokeColor(UIColor.darkGray.cgColor)
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
    let thisProject = Project(projectUUID: projectUUID, users: user, lines: lines, name: projectName)
    APIController.shared.send(project: thisProject)
  }
  
  @IBAction func UpdateTapped(_ sender: UIBarButtonItem)
  {
    APIController.shared.getLine()
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
      drawFromPoint(start: startPoint, toPoint: endPoint)
      self.start = endPoint
    }
  }
}









