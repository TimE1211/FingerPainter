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
//      loginTapped(UIButton)
    }
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    let username: String
    let password: String
    
    if usernameTextField.text != ""
    {
      username = usernameTextField.text!
    }
    else
    {
      username = ""
      alert(name: "username")
    }
    
    if passwordTextField.text != ""
    {
      password = passwordTextField.text!
    }
    else
    {
      password = ""
      alert(name: "password")
    }
    
    if segue.identifier == "LoginSegue"
    {
      let VC = segue.destination as! ViewController
      VC.username = username
      VC.password = password
    }
  }
  
  @IBAction func loginTapped(_ sender: UIButton)
  {
  }
}

extension LoginScreenViewController
{
  func alert(name: String)
  {
    let errorAlert = UIAlertController(title: "Error", message: "Please enter a \(name).", preferredStyle: .alert)
    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
    errorAlert.addAction(action)
    self.present(errorAlert, animated: true, completion: nil)
  }
}
