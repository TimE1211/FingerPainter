//
//  ProjectsTableViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProjectsTableViewController: UITableViewController
{
  var projects = [Project]()
  
  var projectToJoinId = Int()
  var joinProjectsTappedBool = false
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    APIController.shared.projectDelegate = self
    APIController.shared.getProjects()
//    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//    backgroundImage.image = UIImage(named: "colourback_9006.jpg")
//    self.view.insertSubview(backgroundImage, at: 0)
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return projects.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
    
    let thisProject = projects[indexPath.row]
    cell.textLabel?.text = thisProject.projectName
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    let thisProject = projects[indexPath.row]
    Project.current = thisProject
    performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
  }
 
  @IBAction func NewProjectTapped(_ sender: UIBarButtonItem)
  {
    let alert = UIAlertController(title: "New Project", message: "Please Enter a name for your Project then Confirm", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "Project name"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let projectName = alert.textFields?.first?.text, projectName != "" else
      {
        self.pleaseEnterANameAlert()
        return
      }
      
      Project.current = Project(user1Id: User.current.id, lines: [], projectName: projectName)
      APIController.shared.create(project: Project.current, completionHandler: { result, error in
        if let result = result
        {
          Project.current = Project(json: result)
          self.performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
        }
        else
        {
          let errorAlert = UIAlertController(title: "Project could not be saved successfully", message: "Please restart the app and try again", preferredStyle: .alert)
          let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
          errorAlert.addAction(action)
          self.present(errorAlert, animated: true, completion: nil)
        }
      })
      
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func joinProjectsTapped(_ sender: UIBarButtonItem)
  {
    joinProjectsTappedBool = true
    let alert = UIAlertController(title: "projectId", message: "Please Enter the id for the Project you wish to join then Confirm", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "Enter projectId"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let projectId = alert.textFields?.first?.text, projectId != "" else
      {
        self.pleaseEnterDataAlert()
        return
      }
      if let projId = Int(projectId)
      {
        self.projectToJoinId = projId
        APIController.shared.getProjects()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func logOutTapped(_ sender: UIBarButtonItem)
  {
    User.current = nil
    self.dismiss(animated: true, completion: nil)
  }
}

extension ProjectsTableViewController: APIControllerProjectDelegate   //api
{
  func apiControllerDidReceive(projectDictionary: [[String: Any]])
  {
    getProjectsForUser(projectDictionary: projectDictionary)
    
    if joinProjectsTappedBool
    {
      getProjectForprojectId(projectDictionary: projectDictionary)
      joinProjectsTappedBool = false
    }
  }
  
  func getProjectsForUser(projectDictionary: [[String: Any]])
  {
    projects.removeAll()
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      if project.user1Id == User.current.id || project.user2Id == User.current.id
      {
        projects.append(project)
      }
    }
    self.tableView.reloadData()
    print("projects count: \(projects.count)")
  }
  
  func getProjectForprojectId(projectDictionary: [[String: Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      if project.id == projectToJoinId
      {
        Project.current = project
        projectToJoinId = 0
        performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
      }
    }
    pleaseEnterDataAlert()
  }
}

extension ProjectsTableViewController       //alerts
{
  func pleaseEnterANameAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please name your Project", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func pleaseEnterDataAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please enter a valid Project id to join or select an existing Project", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}
