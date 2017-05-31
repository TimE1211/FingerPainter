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
  var projectName = String()
  var projectUUID = String()
  
  var projectToJoinUUID = String()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    APIController.shared.getProjects()
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

    title = "My Projects"
    
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
      textField.placeholder = "Enter Username"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let projectName = alert.textFields?.first?.text, projectName != "" else
      {
        self.pleaseEnterANameAlert()
        return
      }
      
      self.projectName = projectName
      self.projectUUID = UUID().uuidString
      
      Project.current = Project(projectUUID: self.projectUUID, users: [User.current], lines: [], projectName: projectName)
      self.performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func joinProjectsTapped(_ sender: UIBarButtonItem)
  {
    //call api and get project with project id that u paste in via alert
    let alert = UIAlertController(title: "ProjectUUID", message: "Please Enter a UUID for the Project you wish to join then Confirm", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "Enter ProjectUUID"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let projectUUID = alert.textFields?.first?.text, projectUUID != "" else
      {
        self.pleaseEnterDataAlert()
        return
      }
      self.projectToJoinUUID = projectUUID
      APIController.shared.getProjects()
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
    getProjectForProjectUUID(projectDictionary: projectDictionary)
  }
  
  func getProjectsForUser(projectDictionary: [[String: Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      let userFoundInArray = project.users.filter({ $0.username == User.current.username })
      if userFoundInArray.count == 1
      {
        // current user was found in the project so append to projects array to display project as cell
        projects.removeAll()
        projects.append(project)
      }
    }
    self.tableView.reloadData()
  }
  
  func getProjectForProjectUUID(projectDictionary: [[String: Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
        if project.projectUUID == projectToJoinUUID
      {
        //projectUUID's match so this is the project I want to join
        Project.current = project
        performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
      }
    }
  }
}

extension ProjectsTableViewController       //alert
{
  func pleaseEnterANameAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please name your Project.", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func pleaseEnterDataAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please a ProjectUUID.", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}
