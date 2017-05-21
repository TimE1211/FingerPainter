//
//  ViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/15/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
  @IBOutlet weak var canvas: UIImageView!
  var start: CGPoint?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    start = touches.first?.location(in: canvas)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    if let touch = touches.first
    {
      let end = touch.location(in: canvas)
      
      if let start = self.start
      {
        drawFromPoint(start: start, toPoint: end)
      }
      self.start = end
    }
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
    }
  }
  
  @IBAction func clearTapped(_ sender: UIBarButtonItem)
  {
    canvas.image = nil
  }
  
  
  
  
  
  
  
}

