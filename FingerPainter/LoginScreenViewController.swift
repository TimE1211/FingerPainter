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
  
  var username: String
  var password: String
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    usernameTextField.becomeFirstResponder()
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    
    if let text = usernameTextField.text, text != ""
    {
      username = text
    }
    else
    {
      username = ""
      incorrectKeyTyped(key: "username")
    }
    
    if let text = passwordTextField.text, text != ""
    {
      password = text
    }
    else
    {
      password = ""
      incorrectKeyTyped(key: "password")
    }
    
    if segue.identifier == "LoginSegue", let vc = segue.destination as? ViewController
    {
      vc.username = username
      vc.password = password
    }
//    else
//    {
//      fatalError()
//    }
  }
  
  @IBAction func loginTapped(_ sender: UIButton)
  {
    login()
  }
  
  func login()
  {
//    APIController.shared.getUserData
    if username == apiUsername && if password == apiPassword
    {
      
    }
  }
  
}

extension LoginScreenViewController         //invalid key(name/pass) entered
{
  func incorrectKeyTyped(key: String)
  {
    let errorAlert = UIAlertController(title: "Error", message: "Please enter a valid \(key).", preferredStyle: .deviceSpecific)
    
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
  func apiControllerDidReceive(userDictionary: [String : Any])
  {
    
  }
  
}
