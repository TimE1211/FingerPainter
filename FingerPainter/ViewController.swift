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
      let line = Line(json: JSON(aLine))
      let startPoint = CGPoint(x: line.startx, y: line.starty)
      let endPoint = CGPoint(x: line.endx, y: line.endy)
      lines.removeAll()
      //remove all lines in lines variable and use proj information from api to load in all lines for this proj
      lines.append(line)
      if let thickness = thickness
      {
        drawFromPoint(start: startPoint, toPoint: endPoint, with: line.color, and: thickness)
        self.start = endPoint
      }
    }

    let userFoundInArray = Project.current.users.filter({ $0.username == User.current.username })
    if userFoundInArray.count == 0
    {
      // current user was not found in the array add to projects users array
      Project.current.users.append(User.current)
    }
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
      
        if let line = Line(startx: Double(start.x), starty: Double(start.y), endx: Double(end.x), endy: Double(end.y), color: color, thickness: thickness)
        {
          lines.append(line)
          Project.current.lines = lines
          APIController.shared.save(project: Project.current)
        }
        self.start = end
      }
    }
  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint, with color: String, and thickness: Double)
  {
    UIGraphicsBeginImageContext(canvas.frame.size)
    if let context = UIGraphicsGetCurrentContext()
    {
      canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
      if color == "black"
      {
        context.setStrokeColor(UIColor.darkGray.cgColor)
      }
      else if color == "white"
      {
        context.setStrokeColor(UIColor.white.cgColor)
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
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem)
  {
    Project.current.lines = lines
    APIController.shared.save(project: Project.current)
  }
  
  func timer()
  {
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false)
    { timer in
      APIController.shared.getProjects()
    }
  }
}

extension ViewController: APIControllerProjectDelegate    //updating lines
{
  func apiControllerDidReceive(projectDictionary: [[String : Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      if project.projectUUID == Project.current.projectUUID
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
  func colorChanged(color: String)
  {
    self.color = color
  }
  func thicknessChanged(thickness: Double)
  {
    self.thickness = thickness
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    //thickness = starting thickness in setting vc
//    color = starting color in settings vc
  }
}
