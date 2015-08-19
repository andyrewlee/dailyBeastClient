//
//  SettingsViewController.swift
//  dailyBeast
//
//  Created by Jae Hoon Lee on 8/19/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func sliderMoved(sender: UISlider) {
        if sender.tag == 0 {
            NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: "rate")
        } else if sender.tag == 1 {
            NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: "pitch")
        } else if sender.tag == 2 {
            NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: "volume")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 2.0
        
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        
        let settings = NSUserDefaults.standardUserDefaults() as NSUserDefaults!
        
        var rate: Float!
        var pitch: Float!
        var volume: Float!
        
        if let _ = settings.objectForKey("rate") {
            rate = settings.valueForKey("rate") as! Float
        } else {
            rate = AVSpeechUtteranceDefaultSpeechRate
        }
        
        if let _ = settings.objectForKey("pitch") {
            pitch = settings.valueForKey("pitch") as! Float
        } else {
            pitch = 1.25
        }
        
        if let _ = settings.objectForKey("volume") {
            volume = settings.valueForKey("volume") as! Float
        } else {
            volume = 0.5
        }
        
        
        
        rateSlider.setValue(rate, animated: true)
        pitchSlider.setValue(pitch, animated: true)
        volumeSlider.setValue(volume, animated: true)
    }

    @IBAction func defaultSettingsPressed(sender: UIButton) {
        rateSlider.setValue(AVSpeechUtteranceDefaultSpeechRate, animated: true)
        pitchSlider.setValue(1.25, animated: true)
        volumeSlider.setValue(0.5, animated: true)
        
        NSUserDefaults.standardUserDefaults().setFloat(AVSpeechUtteranceDefaultSpeechRate, forKey: "rate")
        NSUserDefaults.standardUserDefaults().setFloat(1.25, forKey: "pitch")
        NSUserDefaults.standardUserDefaults().setFloat(0.5, forKey: "volume")
        
    }
}
