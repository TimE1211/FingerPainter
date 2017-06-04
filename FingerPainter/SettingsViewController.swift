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
  
  @IBOutlet weak var lineThicknessLabel: UILabel!
  @IBOutlet weak var lineThicknessSlider: UISlider!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    lineThicknessLabel.text = "Line Thickness: \(lineThicknessSlider.value)"
    
    if let control = lineColorSegmentedController
    {
      control.removeAllSegments()
      
      for (index, color) in ColorOption.all.enumerated()
      {
        control.insertSegment(withTitle: color.rawValue.capitalized, at: index, animated: false)
      }
      
      let selected = Settings.shared.lineColor
      if let index = ColorOption.all.index(of: selected)
      {
        control.selectedSegmentIndex = index
        control.tintColor = UIColor.from(colorOption: selected)
      }
    }
    
    if let slider = lineThicknessSlider
    {
      slider.maximumValue = 20
      slider.minimumValue = 1
      slider.value = Float(Settings.shared.lineWidth)
      lineThicknessLabel.text = String(Settings.shared.lineWidth)
    }
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func lineColorValueChanged(_ sender: UISegmentedControl)
  {
    let selected = ColorOption.all[sender.selectedSegmentIndex]
    Settings.shared.lineColor = selected
    
    UIView.animate(withDuration: 0.25) {
//      let colorOption: ColorOption = (selected == .white) ? .black : selected
      sender.tintColor = UIColor.from(colorOption: selected)
    }
  }
  
  @IBAction func lineThicknessSliderValueChanged(_ sender: UISlider)
  {
    lineThicknessLabel.text = String(sender.value)
    Settings.shared.lineWidth = Double(sender.value)
  }
  
  @IBAction func doneButtonTapped(_ sender: UIButton)
  {
    self.dismiss(animated: true, completion: nil)
  }
}
