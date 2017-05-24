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
  
  var username = [User]()
  var password = String()
  var projectName = String()
  var id = UUID.init()
  
  var status: DrawingStatus = .none
  {
    didSet {
      if status == .ended, let line = Line(start: start, end: end)
      {
        APIController.shared.send(line: line)
        status = .none
      }
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    APIController.shared.lineDelegate = self
    Project(id: id, users: username, lines: [], name: projectName)
    APIController.shared.send(project)
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
      status = .started
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    status = .drawing
    if let touch = touches.first
    {
      end = touch.location(in: view)
      
      if let start = start
      {
        drawFromPoint(start: start, toPoint: end!)
      }
      self.start = end
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    status = .ended
  }
  
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
      //make api post here maybe as you draw is pushing every few .1 s and other device is pulling the same interval somewhere else in the code
      //when am i going to get api data
      
    }
  }
  
  @IBAction func clearTapped(_ sender: UIBarButtonItem)
  {
    canvas.image = nil
  }
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem)
  {
    APIController.shared.getLine()
  }
  
}

extension ViewController: APIControllerLineDelegate
{
  func apiControllerDidReceive(lineDictionary: [String : Any])
  {
    let aLine = Line(json: JSON(lineDictionary))
    let startPoint = CGPoint(x: aLine.start.x, y: aLine.start.y)
    let endPoint = CGPoint(x: aLine.end.x, y: aLine.end.y)
    drawFromPoint(start: startPoint, toPoint: endPoint)
  }
  
}









