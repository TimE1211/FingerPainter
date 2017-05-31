//
//  SettingsViewController.swift
//  FingerPainter
//
//  Created by Timothy Hang on 5/31/17.
//  Copyright © 2017 Timothy Hang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
  @IBOutlet weak var lineColorSegmentedController: UISegmentedControl!
  var color = ""
  var thickness = Double()
 
  @IBOutlet weak var lineThicknessLabel: UILabel!
  @IBOutlet weak var lineThicknessSlider: UISlider!
  
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
    }
    else
    {
      color = "white"
    }
  }
  @IBAction func lineThicknessSliderValueChanged(_ sender: UISlider)
  {
    lineThicknessLabel.text = "Line Thickness: \(lineThicknessSlider.value)"
    thickness = Double(lineThicknessSlider.value)
  }
}
