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
  
  var thisProjectIndex = Int()
  
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
    thisProjectIndex = indexPath.row
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
        self.PleaseEnterANameAlert()
        return
      }
      
      self.projectName = projectName
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
    projectUUID = UUID().uuidString
    
    Project.current = Project(projectUUID: projectUUID, users: [User.current], lines: [], projectName: projectName)
    
    performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
  }
  
  @IBAction func joinProjectsTapped(_ sender: UIBarButtonItem)
  {
    //call api and get project with project id that u paste in via alert
    //api finds that project and sets it as Project.current
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
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      if project.users.contains(User.current)
      {
        projects.append(project)
      }
      
    }
    self.tableView.reloadData()
  }
}

extension ProjectsTableViewController       //alert
{
  func PleaseEnterANameAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please name your Project.", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}
