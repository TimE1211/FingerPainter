//
//  LoginScreenViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/23/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginScreenViewController: UIViewController, UITextFieldDelegate
{
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var username = String()
  var password = String()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
//    usernameTextField.becomeFirstResponder()
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
  
  @IBAction func loginTapped(_ saveer: UIButton)
  {
    login()
  }
  
  func login()
  {
    guard let username = usernameTextField.text, username != "",
      let password = passwordTextField.text, password != "" else
    {
      self.incorrectKeyTyped(key: "Username and Password")
      return
    }
    
    User.current = User(username: username, password: password)
    APIController.shared.getUsers()
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
    
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let `self` = self else { return }
      
      guard let username = alert.textFields?.first?.text, username != "",
        let password = alert.textFields?.last?.text, password != "" else
      {
        self.incorrectKeyTyped(key: "Username and Password")
        return
      }
      
      User.current = User(username: username, password: password)
      
      APIController.shared.create(user: User.current, completionHandler: { result, error in
        if result != nil
        {
          self.presentSuccessfullyRegisteredAlert()
          self.usernameTextField.text = User.current.username
          self.passwordTextField.text = User.current.password
          self.login()
        }
        else
        {
          self.userRegistrationErrorAlert()
        }
      })
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
//  @IBAction  func prepareForUnwind(segue: UIStoryboardSegue, sender: UIButton)
//  {
//  }
}

extension LoginScreenViewController: APIControllerUserDelegate          //getting users to check login info
{
  func apiControllerDidReceive(userDictionary: [[String : Any]])
  {
    var userInfoIsCorrect = false
    for aUser in userDictionary
    {
      let user = User(json: JSON(aUser))
      if User.current.username == user.username && User.current.password == user.password
      {
        userInfoIsCorrect = true
      }
    }
    
    if userInfoIsCorrect == true
    {
      performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    else
    {
      incorrectKeyTyped(key: "Username and Password combination")
    }
  }
}


extension LoginScreenViewController         //alerts
{
  func incorrectKeyTyped(key: String)
  {
    let errorAlert = UIAlertController(title: "Error - Incorrect Data", message: "Please enter a valid \(key).", preferredStyle: .deviceSpecific)
    
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func userRegistrationErrorAlert()
  {
    let errorAlert = UIAlertController(title: "Username already exists/ or User could not be saved successfully", message: "Please enter a different Username", preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func presentSuccessfullyRegisteredAlert()
  {
    let successAlert = UIAlertController(title: "Congratulations", message: "Successfully Registered and Logging In", preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    successAlert.addAction(action)
    self.present(successAlert, animated: true, completion: nil)
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

