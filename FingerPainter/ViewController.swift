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

class ViewController: UIViewController
{
  @IBOutlet weak var canvas: UIImageView!
  
  var start: CGPoint?
  var end: CGPoint?
  var color: String? = "black"
  var thickness: Double? = 5
  
  var lines = [Line]()
  
  let settingsViewController = SettingsViewController()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    title = "\(Project.current.projectName)"
    APIController.shared.projectDelegate = self
    
    settingsViewController.settingsDelegate = self

    timer()
    
    for aLine in Project.current.lines
    {
      let startPoint = CGPoint(x: aLine.startx, y: aLine.starty)
      let endPoint = CGPoint(x: aLine.endx, y: aLine.endy)
      lines.removeAll()
      
      drawFromPoint(start: startPoint, toPoint: endPoint, with: aLine.color, and: aLine.thickness)
      self.start = endPoint
    }
    
    if Project.current.user1Id != User.current.id
    {
      // current user was not found in the array add to projects users array
      Project.current.user2Id = User.current.id
    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  func timer()
  {
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false)
    { timer in
      APIController.shared.getProjects()
    }
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
      self.end = touch.location(in: view)
      if let end = end, let start = start, let color = color, let thickness = thickness
      {
        drawFromPoint(start: start, toPoint: end, with: color, and: thickness)
      
        if let line = Line(projectId: Project.current.id, startx: Double(start.x), starty: Double(start.y), endx: Double(end.x), endy: Double(end.y), color: color, thickness: thickness)
        {
          lines.append(line)
          Project.current.lines = lines
          APIController.shared.update(project: Project.current)
          //updating current proj maybe shouldnt be using save -> update
        }
        self.start = end
      }
    }
  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint, with color: String, and thickness: Double)
  {
    print(color)
    UIGraphicsBeginImageContext(canvas.frame.size)
    if let context = UIGraphicsGetCurrentContext()
    {
      canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
      if color == "white"
      {
        context.setStrokeColor(UIColor.white.cgColor)
      }
      else
      {
        context.setStrokeColor(UIColor.darkGray.cgColor)
      }
      
      context.setLineWidth(CGFloat(thickness))
      context.beginPath()
      context.move(to: CGPoint(x: start.x, y: start.y))
      context.addLine(to: CGPoint(x: end.x, y: end.y))
      context.strokePath()
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      canvas.image = newImage
    }
  }
  
  @IBAction func backButtonTapped(_ sender: UIBarButtonItem)
  {
    self.dismiss(animated: true, completion: nil)
  }
}

extension ViewController: APIControllerProjectDelegate    //updating lines
{
  func apiControllerDidReceive(projectDictionary: [[String : Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      if project.id == Project.current.id
      {
        lines = project.lines
      }
    }
    for line in lines
    {
      let startPoint = CGPoint(x: line.startx, y: line.starty)
      let endPoint = CGPoint(x: line.endx, y: line.endy)
      drawFromPoint(start: startPoint, toPoint: endPoint, with: line.color, and: line.thickness)
    }
  }
}

extension ViewController: SettingsViewControllerDelegate      //changed settings
{
  func settingsViewControllerDidSend(color: String)
  {
    self.color = color
  }
  func settingsViewControllerDidSend(thickness: Double)
  {
    self.thickness = thickness
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    //thickness = starting thickness in setting vc
//    color = starting color in settings vc
  }
}
