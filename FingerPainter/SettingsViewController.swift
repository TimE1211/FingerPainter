//
//  SettingsViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/31/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate
{
  func settingsViewControllerDidSend(color: String)
  func settingsViewControllerDidSend(thickness: Double)
}

class SettingsViewController: UIViewController
{
  var color = ""
  var thickness = Double()
  
  @IBOutlet weak var lineColorSegmentedController: UISegmentedControl!
  
  @IBOutlet weak var lineThicknessLabel: UILabel!
  @IBOutlet weak var lineThicknessSlider: UISlider!
  
  var settingsDelegate: SettingsViewControllerDelegate?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    lineThicknessLabel.text = "Line Thickness: \(lineThicknessSlider.value)"
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func lineColorValueChanged(_ sender: UISegmentedControl)
  {
    if lineColorSegmentedController.selectedSegmentIndex == 0
    {
      color = "black"
      print(color)
      settingsDelegate?.settingsViewControllerDidSend(color: color)
    }
    else
    {
      color = "white"
      print(color)
      settingsDelegate?.settingsViewControllerDidSend(color: color)
    }
  }
  
  @IBAction func lineThicknessSliderValueChanged(_ sender: UISlider)
  {
    lineThicknessLabel.text = "Line Thickness: \(lineThicknessSlider.value)"
    thickness = Double(lineThicknessSlider.value)
    print(String(thickness))
    settingsDelegate?.settingsViewControllerDidSend(thickness: thickness)
  }
  
  @IBAction func doneButtonTapped(_ sender: UIButton)
  {
    self.dismiss(animated: true, completion: nil)
  }
}
