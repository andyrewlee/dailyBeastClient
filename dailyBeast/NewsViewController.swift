//
//  NewsViewController.swift
//  dailyBeast
//
//  Created by Jae Hoon Lee on 8/18/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//


import UIKit
import AVFoundation

class NewsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    // MARK: Properties
    
    var url = ""
    var headline = ""
    let synthesizer = AVSpeechSynthesizer()
    var isReading: Bool = false
    var firstTimeReading: Bool = true
    
    // MARK: Outlets
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func readButtonPressed(sender: UIButton) {
        if isReading {
            isReading = false
            sender.setTitle("Read", forState: .Normal)
            synthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
        } else {
            isReading = true
            sender.setTitle("Pause", forState: .Normal)
            let utterance = AVSpeechUtterance(string: contentLabel.text!)
            utterance.rate = rate
            utterance.pitchMultiplier = pitch
            utterance.volume = volume
            
            if firstTimeReading {
                synthesizer.speakUtterance(utterance)
                firstTimeReading = false
            } else {
                synthesizer.continueSpeaking()
            }
        }
    }
    
    // MARK: Methods
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSArray
        } catch {
            return nil
        }
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mainButton.setTitle("Read", forState: .Normal)
        isReading = false
        firstTimeReading = true
        
        let settings = NSUserDefaults.standardUserDefaults() as NSUserDefaults!
        
        
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
        
        headlineLabel.text = ""
        contentLabel.text = ""
        if let urlToReq = NSURL(string: "https://secure-earth-3377.herokuapp.com\(url)") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfStory = parseJSON(data)
                contentLabel.text = arrOfStory![0] as? String
                headlineLabel.text = headline
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        contentLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        contentLabel.attributedText = NSAttributedString(string: utterance.speechString)
    }
}