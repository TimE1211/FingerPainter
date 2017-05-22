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

enum DrawingStatus {
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
  
  var status: DrawingStatus = .none {
    didSet{ didSet(status: status) }
  }
  
  let pointService = PointServiceManager()
  
  func didSet(status: DrawingStatus) {
    if status == .ended {
      //api call
      //status = .none
    }
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    pointService.delegate = self
    apiController.delegate = self
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    start = touches.first?.location(in: canvas)
    pointService.send(point: start!)
    status = .started
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    status = .drawing
    if let touch = touches.first
    {
      end = touch.location(in: canvas)
      
      pointService.send(point: end!)
      
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
}

extension ViewController : PointServiceManagerDelegate
{
  func connectedDevicesChanged(manager: PointServiceManager, connectedDevices: [String])
  {
    //    OperationQueue.main.addOperation {
    //      self.connectionsLabel.text = "Connections: \(connectedDevices)"
    //    }
  }
  
  func pointChanged(manager: PointServiceManager, point: CGPoint)
  {
    apiController.getPoints()
    OperationQueue.main.addOperation {
      self.drawFromPoint(start: self.start!, toPoint: self.end!)
    }
  }
}

extension ViewController : APIControllerDelegate
{
  func pointsReceived(_ points: CGPoint)
  {
    self.drawFromPoint(start: start!, toPoint: end!)
  }
}











