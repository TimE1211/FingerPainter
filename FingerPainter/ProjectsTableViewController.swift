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
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    APIController.shared.getProjects()
//    get projects for specific user and projects that this user has worked on
    
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
//    if section == 0
//    {
//      section.title.text = "My Projects"
//    }
//    else if section == 1
//    {
//      section.title.text = "Friends Projects"
//    }
    title = "My Projects"
    
    let thisProject = projects[indexPath]
    cell.textLabel.text = thisProject.projectName
    
    return cell
  }

  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
      if editingStyle == .delete
      {
          // Delete the row from the data source
          tableView.deleteRows(at: [indexPath], with: .fade)
      }
//      else if editingStyle == .insert
//      {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//      }    
  }

//  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//  {
//    if segue.identifier == "ProjectSegue", let vc = segue.destination as? ViewController
//    {
//      vc.users.append(User.current)
//      vc.projectName = projectName
//      vc.projectUUID = projectUUID
//    }
//    else if segue.identifier == "ExistingProjectSegue", let vc = segue.destination as? ViewController
//    {
//      if vc.users contains 
//    }
//  }
 
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
    print(projectUUID)
    Project.current = Project(projectUUID: projectUUID, users: [User.current], lines: [], name: projectName)
    performSegue(withIdentifier: "ProjectSegue", sender: Project.current)
  }

  @IBAction func logOutTapped(_ sender: UIBarButtonItem)
  {
    // maybe move unwind to view controller since this is only going back one vc but do need a log out button
    User.current = nil
//    go back to login
  }
}

extension ProjectsTableViewController: APIControllerProjectDelegate
{
  func apiControllerDidReceive(projectDictionary: [[String: Any]])
  {
    for aProject in projectDictionary
    {
      let project = Project(json: JSON(aProject))
      projects.append(project)
    }
  }
}

extension ProjectsTableViewController
{
  func PleaseEnterANameAlert()
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please name your Project.", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}
