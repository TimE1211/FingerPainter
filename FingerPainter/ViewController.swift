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
import RealmSwift

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
  
  var apiController = APIController()
  
  var username = String()
  var password = String()
  var sessionID = Int()
  
  var status: DrawingStatus = .none
  {
    didSet {
      if status == .ended
      {
        apiController.getEndingPoint()
        status = .none
      }
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    apiController.delegate = self
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    start = touches.first?.location(in: view)
    apiController.send(startingPoint: start!)
    status = .started
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    status = .drawing
    if let touch = touches.first
    {
      end = touch.location(in: view)
      
      apiController.send(endingPoint: end!)
      
      if let start = self.start
      {
        drawFromPoint(start: start, toPoint: end!)
      }
      self.start = end
      self.end = nil
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    status = .ended
  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint)
  {
    if let context = UIGraphicsGetCurrentContext()
    {
      UIGraphicsBeginImageContext(canvas.frame.size)
      canvas.image!.draw(in: canvas.bounds)
      context.setLineWidth(5)
      context.setStrokeColor(UIColor.magenta.cgColor)
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
    
  }
  
}

extension ViewController : APIControllerDelegate
{
  func apiControllerDidReceive(startPointDictionary: [String : Any])
  {
    let aPoint = Point(pointDictionary: startPointDictionary)
    let startPoint = CGPoint(x: aPoint.x, y: aPoint.y)
  }
  
  func apiControllerDidReceive(endPointDictionary: [String : Any])
  {
    let aPoint = Point(pointDictionary: endPointDictionary)
    let endPoint = CGPoint(x: aPoint.x, y: aPoint.y)
    
  }
  
  
}











