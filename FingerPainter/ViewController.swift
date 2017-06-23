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
  
  var lines = [Line]()
  
  var timer: Timer?
  
  let settingsViewController = SettingsViewController()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    print(Project.current)
    APIController.shared.projectDelegate = self
    
    if Project.current.user1Id != User.current.id
    {
      Project.current.user2Id = User.current.id
      let updatingProject = Project(user1Id: Project.current.user1Id, lines: [], projectName: Project.current.projectName)
      updatingProject.user2Id = Project.current.user2Id
      updatingProject.id = Project.current.id
      APIController.shared.update(project: updatingProject)
    }
    
    for aLine in Project.current.lines
    {
      let startPoint = CGPoint(x: aLine.startx, y: aLine.starty)
      let endPoint = CGPoint(x: aLine.endx, y: aLine.endy)
      lines.removeAll()
      
      drawFromPoint(start: startPoint, toPoint: endPoint, with: ColorOption(rawValue: aLine.color)!, and: aLine.thickness)
      self.start = endPoint
    }
    
    title = "\(Project.current.projectName)"
    
    if timer == nil {
      makeTimer()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    timer = nil
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  func makeTimer()
  {
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
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
      if let end = end, let start = start
      {
        let thickness = Settings.shared.lineWidth
        let color = Settings.shared.lineColor
        
        drawFromPoint(start: start, toPoint: end, with: color, and: thickness)
      
        if let line = Line(projectId: Project.current.id, startx: Double(start.x), starty: Double(start.y), endx: Double(end.x), endy: Double(end.y), color: color.rawValue, thickness: thickness)
        {
          lines.append(line)
          let newLine = line
          Project.current.lines = lines
          
          let updatingProject = Project(user1Id: Project.current.user1Id, lines: [newLine], projectName: Project.current.projectName)
          updatingProject.user2Id = Project.current.user2Id
          updatingProject.id = Project.current.id
          
          APIController.shared.update(project: updatingProject)
        }
        self.start = end
      }
    }
  }
  
  func drawFromPoint(start: CGPoint, toPoint end: CGPoint, with colorOption: ColorOption, and thickness: Double)
  {
    UIGraphicsBeginImageContext(canvas.frame.size)
    if let context = UIGraphicsGetCurrentContext()
    {
      canvas.image?.draw(in: CGRect(x: 0, y: 0, width: canvas.frame.size.width, height: canvas.frame.size.height))
      
      let color = UIColor.from(colorOption: colorOption)
      context.setStrokeColor(color.cgColor)
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
  
  @IBAction func inviteButtonTapped(_ sender: UIBarButtonItem)
  {
    let projectId = Project.current.id
    UIPasteboard.general.string = "\(projectId)"
    
    let alert = UIAlertController(title: "Copied", message: "Copied to clipboard: " + "\(projectId)", preferredStyle: .alert)
    
    present(alert, animated: true) {
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
        timer.invalidate()
        alert.dismiss(animated: true, completion: nil)
      }
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
      if project.id == Project.current.id
      {
        lines = project.lines
//      not pulling down all the lines here
      }
    }
    
    for line in lines
    {
//      print(line.color)
      let startPoint = CGPoint(x: line.startx, y: line.starty)
      let endPoint = CGPoint(x: line.endx, y: line.endy)
      if let lineColor = ColorOption(rawValue: line.color)
      {
        drawFromPoint(start: startPoint, toPoint: endPoint, with: lineColor, and: line.thickness)
      }
      else
      {
        drawFromPoint(start: startPoint, toPoint: endPoint, with: ColorOption(rawValue: "black")!, and: line.thickness)
      }
    }
    Project.current.lines = lines
  }
}
