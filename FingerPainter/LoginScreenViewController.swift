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
    usernameTextField.autocorrectionType = .no
    passwordTextField.autocorrectionType = .no
    passwordTextField.isSecureTextEntry = true
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    APIController.shared.userDelegate = self
    super.viewDidLoad()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "colourback_9006.jpg")
    self.view.insertSubview(backgroundImage, at: 0)
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
      textField.autocorrectionType = .no
    }
    
    alert.addTextField { textField in
      textField.placeholder = "Enter Password"
      textField.keyboardType = .default
      textField.isSecureTextEntry = true
      textField.autocorrectionType = .no
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
      
      APIController.shared.save(user: User.current, completionHandler: { result, error in
        if let result = result
        {
          print(result)
          User.current = User(json: result)
          self.presentSuccessfullyRegisteredAlert()
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
}

extension LoginScreenViewController: APIControllerUserDelegate
{
  func apiControllerDidReceive(userDictionary: [[String : Any]])
  {
    print(userDictionary)
   
    var userInfoIsCorrect = false
    for aUser in userDictionary
    {
      let user = User(json: JSON(aUser))
      if User.current.username == user.username && User.current.password == user.password
      {
        User.current = user
        userInfoIsCorrect = true
      }
    }
    
    if userInfoIsCorrect
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
    let errorAlert = UIAlertController(title: "User could not be saved successfully", message: "Please try again", preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func presentSuccessfullyRegisteredAlert()
  {
    let successAlert = UIAlertController(title: "Congratulations", message: "Successfully Registered and Logging In", preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .default) { _ in
      self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
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

