//
//  LoginScreenViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController, UITextFieldDelegate
{
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var username = String()
  var password = String()
  var user = User()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    usernameTextField.becomeFirstResponder()
    passwordTextField.isSecureTextEntry = true
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    if textField == usernameTextField
    {
      passwordTextField.becomeFirstResponder()
    }
    else if textField == passwordTextField
    {
      passwordTextField.resignFirstResponder()
      login()
    }
    return true
  }
  
  @IBAction func loginTapped(_ sender: UIButton)
  {
    login()
  }
  
  func login()
  {
    if let text = usernameTextField.text, text != ""
    {
      username = text
    }
    else
    {
      username = ""
      incorrectKeyTyped(key: "user")
      //incorrect combination of username and password
    }
    
    if let text = passwordTextField.text, text != ""
    {
      password = text
    }
    else
    {
      password = ""
      incorrectKeyTyped(key: "password")
      //incorrect combination of username and password
    }
    
  }
  
  @IBAction func registerTapped(_ sender: UIButton)
  {
    let alert = UIAlertController(title: "New User", message: "Please Enter a Username and Password then Confirm", preferredStyle: .alert)
    
    alert.addTextField { textField in
      textField.placeholder = "Enter Username"
      textField.keyboardType = .default
    }
    
    alert.addTextField { textField in
      textField.placeholder = "Enter Password"
      textField.keyboardType = .default
    }
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
      guard let text = alert.textFields?.first?.text else { return }

      if let url = URL(string: text), UIApplication.shared.canOpenURL(url)
      {
        self.user.userId = UUID().uuidString
        self.user.username = self.username
        self.user.password = self.password
        APIController.shared.getUser()
//        if username exists do error username exists already
//        APIController.shared.send(user: self.user)
      }
      else
      {
        let errorAlert = UIAlertController(title: "Error", message: "Username already exists", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        errorAlert.addAction(action)
        self.present(errorAlert, animated: true, completion: nil)
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if username == user.username
    {
      if segue.identifier == "LoginSegue", let ProjectsTvc = segue.destination as? ProjectsTableViewController
      {
        ProjectsTvc.user = user
      }
      //    else
      //    {
      //      fatalError()
      //    }
    }
  }
  
  @IBAction  func prepareForUnwind(segue: UIStoryboardSegue, sender: UIButton)
  {
  
  }
}

extension LoginScreenViewController         //invalid key(name/pass) entered
{
  func incorrectKeyTyped(key: String)
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please enter a valid \(key).", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}

extension UIAlertControllerStyle          //for ipads
{
  static var deviceSpecific: UIAlertControllerStyle
  {
    if UIDevice.current.userInterfaceIdiom == .pad
    {
      return .alert
    }
    
    return .actionSheet
  }
}

extension LoginScreenViewController: APIControllerUserDelegate
{
  func apiControllerDidReceive(userDictionary: [[String : Any]])
  {
//    userDictionary to scan thru and check if matches
  }
}
